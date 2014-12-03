Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:38309 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751088AbaLCTST (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Dec 2014 14:18:19 -0500
Message-ID: <547F61F6.7020707@pobox.com>
Date: Wed, 03 Dec 2014 11:18:14 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
CC: David Sterba <dsterba@suse.cz>
Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with SQL?
References: <547BCB43.5020505@cn.fujitsu.com> <547BE8A5.7050900@pobox.com> <547C0834.7090706@cn.fujitsu.com> <547CAF2E.7070109@pobox.com> <547D1339.10404@cn.fujitsu.com>
In-Reply-To: <547D1339.10404@cn.fujitsu.com>
Content-Type: multipart/mixed;
 boundary="------------030806060804030204070301"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030806060804030204070301
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/01/2014 05:17 PM, Qu Wenruo wrote:
> But I am also somewhat tired of bringing new structure new searching
> functions or even bring larger change on
> the btrfsck record infrastructure when I found that can't provide the
> function when new recovery function is going
> to be implemented.

DISCLAIMER: My actual thing is modeling, so coming from the idea that 
btrfsck is basically building a model of the filesystem and comparing 
the theoretically correct model to the actual filesystem as found... and 
having spent nearly zero time inside of the btrfsck code base itself...

I've looked at what I _think_ you are trying to do with the 
lookup/correlate phase finding peer/parent/child references and I'd 
think other things would make sense far more sense than SQL.

C++ Standard Template Library at a minimum, life is too short to 
reinvent data lookups in memory. But its also too short to re-factor SQL 
queries or wait for degenerate full-table scans.

The boost "multi-index container", if you are going to bring in an 
external library, would do you far better for dealing with future 
structural changes. It would directly index the fields of your 
(parent,child,name) relation and let you switch iteration on-the-fly 
(e.g. you can be walking parents and use the same iterator to start 
walking names etc). (there's even a cookbook item for adding an LRU 
cache as a natural index for space-constrained items.) Again you'd have 
to switch over to C++, but it implements exactly what I think you are 
looking for. the multi-index container declaration syntax gets a little 
thick but once declared the usage model is really simple. (you pay 
most-or-all the cost during "update" which is really a remove-then-readd 
but you won't be updating as often as adding so...)

My "crazy-ist idea" would be to maybe mmap all the metadata from the 
filesystem into the process space and build a page-table-like index over 
that. The virtual memory demand paging will become your caching buddy. 
mapped_block+offest gets you directly to the whole native structure. You 
might have to juggle mappings (map and unmap them) on systems with arger 
filesystems but smaller virtual tables (e.g. classic pentium 32 bit). 
Even then, you'd be juggling mappings and the kernel would be doing all 
the real caching. The more data you can leave in the mmapped ranges the 
less storage management takes place in the local code.

IMHO, finding a USB stick to make a swap space on is probably just as 
good, if not better than, doing it with a whole other filesystem and the 
"put my temp files there" option during emergency maintenance.


If the mailing list engine honors attachments, you will find 
FileEntries.h from one of my projects, offered as a simplified example 
of a directory entry cache implemented in a boost multi-index container.

(Note that this is fully working code from an upcoming addition to my 
soruceforge project, so it's not just theoretical implementation ideas.)

struct FileEntry {
   struct NameIndex {};
   struct DirectoryIndex {};
   struct INodeIndex {};
   struct TypedIndex {};
   dev_t         Device;
   long          ParentINode;
   long          INode;
   std::string   Name;
   enum FileType Type;
};

The empty structs inside the struct act as index identifiers/names 
(Because C++ templates only disambiguate on types so 
FileEntry::NameIndex is the type-name of the index of file names (etc).

Any other data could be added to FileEntry without disrupting any 
existing code for indexing or iterating.

The container itself is a little grusome textually ::

typedef multi_index_container<
   FileEntry,
   indexed_by<
     ordered_non_unique<
       tag<FileEntry::NameIndex>,
       member<
         FileEntry,
         std::string,
         &FileEntry::Name
       >
     >,
     ordered_non_unique<
       tag<FileEntry::DirectoryIndex>,
       composite_key<
         FileEntry,
         member<
           FileEntry,
           dev_t,
           &FileEntry::Device
         >,
         member<
           FileEntry,
           long,
           &FileEntry::ParentINode
         >
       >
     >,
     ordered_non_unique<
       tag<FileEntry::INodeIndex>,
       composite_key<
         FileEntry,
         member<
           FileEntry,
           dev_t,
           &FileEntry::Device
         >,
         member<
           FileEntry,
           long,
           &FileEntry::INode
         >
       >
     >,
     ordered_non_unique<
       tag<FileEntry::TypedIndex>,
       composite_key<
         FileEntry,
         member<
           FileEntry,
           enum FileType,
           &FileEntry::Type
         >,
         member<
           FileEntry,
           std::string,
           &FileEntry::Name
         >
       >
     >
   >
 > FileSet;


But after that it's super easy to use, uh, if you know STL iterator 
speak anyway. 8-)

Having a file set is easy and typesafe in any type-able context (such as 
a member of another structure, or a global):
FileSet result;

Picking yoru index/view has to be done by (admittedly ugly looking) type
FileSet::index<FileEntry::NameIndex>::type

But then when you make one and plumb it ("result" being the working set
FileSet::index<FileEntry::NameIndex>::type & by_name = 
result.get<FileEntry::NameIndex>();

by_name is now a fully functional view of the set as an iteraterable 
container with elements like by_name.erase(some_name) and such.

It gets you what you say you want from SQL but without all the 
indirection or duplication of SQL.

(Note that the attached example will fill a FileSet object into memory 
with the entire (sub) tree of a file system if you call Fill() with the 
deep selector; or just fill the set with the contents of a single 
directory when the shallow selector is used.

etc.

So anyway. I've been in this modeling space for a while. I looked at 
other means of modeling such as SQL and I decided this one was "the 
best" for what I was doing.

The results are fast, deterministic, and type-safe with no internal 
typecasts or full table scan results.

--------------030806060804030204070301
Content-Type: text/x-chdr;
 name="FileEntries.h"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="FileEntries.h"

#ifndef FILEENTRIES_HPP
#define FILEENTRIES_HPP

/* Part of Underdog. https://underdog.sourceforge.net
 * Released under GPLv3. Other licenses may be available.
 * Robert White © Copyright 2014 <rwhite@pobox.com>
 */

#include <dirent.h>     /* Defines DT_* constants */
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <regex.h>


#include <boost/multi_index_container.hpp>
#include <boost/multi_index/ordered_index.hpp>
#include <boost/multi_index/hashed_index.hpp>
#include <boost/multi_index/identity.hpp>
#include <boost/multi_index/member.hpp>
#include <boost/multi_index/composite_key.hpp>
#include <boost/multi_index/tag.hpp>

#include "FileWrapper.h"

namespace FileEntries {

using namespace ::boost;
using namespace ::boost::multi_index;

enum FileType {
  UnknownFile,
  BlockFile,
  CharFile,
  DirectoryFile,
  PipeFile,
  SymlinkFile,
  SocketFile,
  RegularFile
};

inline
enum FileType
DecodeFileType(const int filetype)
{
  enum FileType retval = UnknownFile;
  switch (filetype) {
  case DT_BLK: retval = BlockFile; break;
  case DT_CHR: retval = CharFile; break;
  case DT_DIR: retval = DirectoryFile; break;
  case DT_FIFO: retval = PipeFile; break;
  case DT_LNK: retval = SymlinkFile; break;
  case DT_REG: retval = RegularFile; break;
  case DT_SOCK: retval = BlockFile; break;
  }
  return retval;
}


struct FileEntry {
  struct NameIndex {};
  struct DirectoryIndex {};
  struct INodeIndex {};
  struct TypedIndex {};
  dev_t		Device;
  long		ParentINode;
  long		INode;
  std::string	Name;
  enum FileType	Type;
};

typedef multi_index_container<
  FileEntry,
  indexed_by<
    ordered_non_unique<
      tag<FileEntry::NameIndex>,
      member<
	FileEntry,
	std::string,
	&FileEntry::Name
      >
    >,
    ordered_non_unique<
      tag<FileEntry::DirectoryIndex>,
      composite_key<
        FileEntry,
        member<
          FileEntry,
	  dev_t,
	  &FileEntry::Device
        >,
        member<
	  FileEntry,
	  long,
	  &FileEntry::ParentINode
        >
      >
    >,
    ordered_non_unique<
      tag<FileEntry::INodeIndex>,
      composite_key<
        FileEntry,
        member<
          FileEntry,
	  dev_t,
	  &FileEntry::Device
        >,
        member<
	  FileEntry,
	  long,
	  &FileEntry::INode
        >
      >
    >,
    ordered_non_unique<
      tag<FileEntry::TypedIndex>,
      composite_key<
        FileEntry,
        member<
          FileEntry,
	  enum FileType,
	  &FileEntry::Type
	>,
	member<
	  FileEntry,
	  std::string,
	  &FileEntry::Name
	>
      >
    >
  >
> FileSet;

  struct regex {
    regex_t	built;
    regex(const std::string pattern):
      built({})
    {
      if (regcomp(&built,pattern.c_str(),REG_EXTENDED|REG_NOSUB) != 0) {
	throw std::exception();
      }
    }
    ~regex()
    {
      regfree(&built);
    }
    bool operator()(const std::string & value) const
    {
      return 0 == regexec(&built,value.c_str(),0,0,0);
    }
  };



  struct selector
  {
    typedef ::std::pair<bool,bool> result_type;
  };

  struct shallow_selector:
    public selector
  {
    regex	include_pattern;
		shallow_selector(const std::string pattern 
		  = ::std::string("^(([^.])|([.][^.])|([.]{2}.))")):
		include_pattern(pattern)
		{
		  return;
		}
    result_type operator()(const FileEntry & ent) const
    {
      return result_type(include_pattern(ent.Name),false);
    }
  };

  struct deep_selector:
    public selector
  {
    regex	include_pattern;
    regex	recurse_pattern;
		deep_selector(
		  const std::string i_pattern = "^(([^.])|([.][^.])|([.]{2}.))",
		  const std::string r_pattern = "^(([^.])|([.][^.])|([.]{2}.))"
		):
		  include_pattern(i_pattern),
		  recurse_pattern(r_pattern)
		{
		  return;
		}
    result_type
    operator()(const FileEntry & ent) const
    {
      bool candidate = (ent.Type == DirectoryFile) || (ent.Type == SymlinkFile);
      return result_type(include_pattern(ent.Name),candidate && recurse_pattern(ent.Name));
    }
  };

  template <
    class U,
    bool First = true,
    bool Second = false
  >
  struct inverted:
    public selector
  {
    const U &	Real;
    inverted(const U & real):
      Real(real)
    {
      return;
    }
    result_type
    operator()(const FileEntry & ent) const
    {
      result_type retval = Real(ent);
      if (First) {
	retval.first = !retval.first;
      }
      if (Second) {
	retval.second = !retval.second;
      }
      return retval;
    }
  };

struct linux_dirent {
  long           d_inode;
  off_t          d_offset;
  unsigned short d_reclen;
  char           d_name[1];
};

union cursor_type {
  char *		ch;
  struct linux_dirent *	ld;
};

template <class U>
void
Fill(int directory_fd,
     FileSet & result,
     const U & selector
    )
{
  FileEntry temp = {};
  int	count;
  char	buffer[1024];
  char*	cursor;
  char*	extent;
  struct stat directory_stat = {};
  fstat(directory_fd,&directory_stat);
  FileSet::index<FileEntry::DirectoryIndex>::type & result_view =
    result.get<FileEntry::DirectoryIndex>();
  temp.Device = directory_stat.st_dev;
  temp.ParentINode = directory_stat.st_ino;
  result_view.erase(
    result_view.lower_bound(boost::make_tuple(temp.Device,temp.ParentINode)),
    result_view.upper_bound(boost::make_tuple(temp.Device,temp.ParentINode))
  );
  lseek(directory_fd,0,SEEK_SET);
  while ((count = syscall(SYS_getdents,directory_fd,buffer,sizeof(buffer))) > 0) {
    int next = 0;
    extent = buffer + count;
    for (cursor = buffer; cursor < extent; cursor += next) {
      linux_dirent * entry = reinterpret_cast<linux_dirent *>(cursor);
      next = entry->d_reclen;
      temp.INode = entry->d_inode;
      temp.Name = entry->d_name;
      temp.Type = DecodeFileType(static_cast<int>(*(cursor + next - 1)));
      ::std::pair<bool,bool> selection = selector(temp);
      if (selection.first) {
        result_view.insert(temp);
      }
      if (selection.second) try {
	FileWrapper subdir(temp.Name,O_DIRECTORY|O_RDONLY,directory_fd);
	Fill(subdir.fd(),result,selector);
      } catch (...) {
	  // No recursion on error, silently, it's just easier.
      }
    }
  }
  return;
}

template <>
void
Fill<const std::string &>(int directory_fd,
     FileSet & result,
     const std::string & selector
    )
{
  return Fill(directory_fd,result,shallow_selector(selector));
}

inline
void
Fill(int directory_fd,
     FileSet & result
    )
{
  return Fill(directory_fd,result,shallow_selector());
}


}
#endif

--------------030806060804030204070301
Content-Type: text/x-chdr;
 name="FileWrapper.h"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="FileWrapper.h"

#ifndef FILEWRAPPER_HPP
#define FILEWRAPPER_HPP

/* Part of Underdog. https://underdog.sourceforge.net
 * Released under GPLv3. Other licenses may be available.
 * Robert White © Copyright 2014 <rwhite@pobox.com>
 */


#include <string>
#include <exception>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>


struct FileWrapper {
  struct BadFile: public std::exception { };
  
  FileWrapper(std::string name, int flags, int base = AT_FDCWD):
    FileDescriptor(openat(base,name.c_str(),flags))
  {
    if (FileDescriptor == -1) {
      throw BadFile();
    }
  }

  explicit
  FileWrapper(const FileWrapper & X):
    FileDescriptor(dup(X.FileDescriptor))
  {
    if (FileDescriptor == -1) {
      throw BadFile();
    }
  }
  
  explicit
  FileWrapper(int other_fd):
    FileDescriptor(dup(other_fd))
  {
    if (FileDescriptor == -1) {
      throw BadFile();
    }
  }
  
  FileWrapper(int other_fd, int new_fd):
    FileDescriptor(dup2(other_fd,new_fd))
  {
    if (FileDescriptor == -1) {
      throw BadFile();
    }
  }
  
  void
  Replace(const FileWrapper & X)
  {
    int newfd = dup(X.FileDescriptor);
    if (newfd != -1) {
      close(FileDescriptor);
      FileDescriptor = newfd;
    }
  }
  
  ~FileWrapper()
  {
    close(FileDescriptor);
  }
  
  operator int() const { return FileDescriptor; }
  int fd() const { return FileDescriptor; }
  
protected:
  int FileDescriptor;

private:
  FileWrapper & operator =(const FileWrapper & X);
};

#endif

--------------030806060804030204070301--

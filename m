From: Neil Schemenauer <nas@arctrix.com>
Subject: Btrfs st_nlink for directories
Date: Fri, 22 Jan 2010 20:28:12 -0600
Message-ID: <20100123022812.GA16124@arctrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

It looks like Btrfs does not follow Unix traditions for st_nlink
attribute of directories. It seems to be always one, no matter the
number of sub-directories.

Is this intentional? I couldn't find it discussed anywhere. I
gather the Mac OS HFS+ doesn't follow traditional st_nlink behavior
as well. The 'find' man page has this note:

   -noleaf
          Do  not  optimize  by  assuming that directories contain 2 fewer
          subdirectories than their  hard  link  count.   This  option  is
          needed  when  searching  filesystems that do not follow the Unix
          directory-link convention, such as CD-ROM or MS-DOS  filesystems
          or  AFS  volume  mount  points.  Each directory on a normal Unix
          filesystem has at least 2 hard  links:  its  name  and  its  `.'
          entry.   Additionally,  its  subdirectories (if any) each have a
          `..'  entry linked to that directory.  When find is examining  a
          directory,  after it has statted 2 fewer subdirectories than the
          directory's link count, it knows that the rest of the entries in
          the directory are non-directories (`leaf' files in the directory
          tree).  If only the files' names need to be examined,  there  is
          no  need  to  stat  them;  this  gives a significant increase in
          search speed.

Regards,

  Neil

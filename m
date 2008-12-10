From: "seth huang" <seth.hg@gmail.com>
Subject: Re: Data De-duplication
Date: Wed, 10 Dec 2008 21:30:32 +0800
Message-ID: <200812102130274537790@gmail.com>
References: <1228862899.8130.1.camel@mattos-laptop>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
To: "Oliver Mattos" <oliver.mattos08@imperial.ac.uk>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

De-duplication is useful in data backup systems because of the high level of data redundancy, but I'm not sure whether it is necessary for a general-purposed fs. If you really want to do so, I will suggest the latter one. File-level de-dup can be implemented in a user-level application.

As I googled the internet, I found a previous discussion on this topic in the mail archive. I hope this will help.
http://markmail.org/message/sdxos4s2bnckven5#query:+page:1+mid:sdxos4s2bnckven5+state:results 

On Tue, Dec 9, 2008 at 10:48 PM, Oliver Mattos
<oliver.mattos08@imperial.ac.uk> wrote:
> Hi,
>
> Say I download a large file from the net to /mnt/a.iso.  I then download
> the same file again to /mnt/b.iso.  These files now have the same
> content, but are stored twice since the copies weren't made with the bcp
> utility.
>
> The same occurs if a directory tree with duplicate files (created with
> bcp) is put through a non-aware program - for example tarred and then
> untarred again.
>
> This could be improved in two ways:
>
> 1)  Make a utility which checks the checksums for all the data extents,
> and if the checksums of data match for two files then check the file
> data, and if the file data matches then keep only one copy.  It could be
> run as a cron job to free up disk space on systems where duplicate data
> is common (eg. virtual machine images)
>
> 2)  Keep a tree of checksums for data blocks, so that a bit of data can
> be located by it's checksum.  Whenever a data block is about to be
> written check if the block matches any known block, and if it does then
> don't bother duplicating the data on disk.  I suspect this option may
> not be realistic for performance reasons.
>
> If either is possible then thought needs to be put into if it's worth
> doing on a file level, or a partial-file level (ie. if I have two
> similar files, can the space used by the identical parts of the files be
> saved)
>
> Has any thought been put into either 1) or 2) - are either possible or
> desired?
>
> Thanks
> Oliver


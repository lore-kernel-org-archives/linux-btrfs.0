From: "Miguel Figueiredo Mascarenhas Sousa Filipe"
	<miguel.filipe@gmail.com>
Subject: Re: Data De-duplication
Date: Wed, 10 Dec 2008 11:52:58 +0000
Message-ID: <f058a9c30812100352l268205a7l259b5bf2bf45aae1@mail.gmail.com>
References: <1228862899.8130.1.camel@mattos-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "Oliver Mattos" <oliver.mattos08@imperial.ac.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1228862899.8130.1.camel@mattos-laptop>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

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

I have a perl script that does this, made by a friend of mine.
First it sweeps a dir/ and stats() every file, putting all files with
same size X in a linked list on a hashtable entry for size X.
Then it will md5sum all files with same bytesize to confirm if they
really are copies of each others.

Because if first only stats, and only md5sum files with "potencial"
duplicates, its faster than regular scripts I've seen.

Do you want this ?


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
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Miguel Sousa Filipe

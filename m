From: Atila Romero <atila.alr@dpf.gov.br>
Subject: Compression of large files
Date: Wed, 27 May 2009 11:10:09 -0300
Message-ID: <4A1D49C1.8070903@dpf.gov.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

During a file write, if the compression doesn't proves to be economical
to a portion of the file, the whole file is marked as nocompress, and
subsequent writes don't use compression at all. This can be seen as a 
feature, as it saves CPU in files like videos. But if the file is a dd
image of a disk, or other types of large files, this behavior is
undesirable, since different portions of the file will have different
compression ratios.
I only became aware of this after searching the source code, after
spending some hours trying to find out why the compression wasn't
working. This can be a really unexpected behavior for a end user who is
looking for compression.
The specific part of the code is at inode.c:
477 <#l477>
                /* flag the file so we don't compress in the future */
478 <#l478>                 btrfs_set_flag(inode, NOCOMPRESS);

How about commenting line 478?

Atila


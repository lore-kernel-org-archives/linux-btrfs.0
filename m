From: Michael Raskin <a0091f122@rambler.ru>
Subject: Re: cleanup after a small data loss on incorrect shutdown.
Date: Fri, 12 Jun 2009 15:48:23 +0400
Message-ID: <4A324087.5000305@rambler.ru>
References: <4A30FC2E.3030804@rambler.ru> <20090612105332.GG3834@think>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080100080702060803050402"
To: Chris Mason <chris.mason@oracle.com>,
	Michael Raskin <a0091f122@rambler.ru>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090612105332.GG3834@think>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080100080702060803050402
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Chris Mason wrote:
>> 	2. I found a file which is listed in the directory, but stat on it
>> returns "No such file or directory". Certainly, rm and unlink cannot
>> remove it. The partition has 14G in use. What can I do to provide a
>> useful piece of FS structure information? How can I remove the file
>> afterwards.
> 
> I'd say to send us the btrfsck output, it will help answer these
> questions.

OK, after cleaning the FS from bad files I managed to run btrfsck. It
reports unresolved reference. The files I cleaned were related to
libattr, so I do not believe a kernel header would be a hardlink to them.

--------------080100080702060803050402
Content-Type: text/plain;
 name="btrfsck.log.cleaned"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="btrfsck.log.cleaned"

root 5 inode 273 errors 0
unresolved ref dir 270 index 2 namelen 4 name attr filetype 0 error 3                                                   
root 5 inode 274 errors 0
unresolved ref dir 271 index 2 namelen 2 name cs filetype 0 error 3                                                     
root 5 inode 275 errors 0
unresolved ref dir 271 index 3 namelen 2 name de filetype 0 error 3                                                     
root 5 inode 276 errors 0
unresolved ref dir 271 index 4 namelen 2 name es filetype 0 error 3                                                     
root 5 inode 277 errors 0
unresolved ref dir 271 index 5 namelen 2 name fr filetype 0 error 3                                                     
root 5 inode 278 errors 0
unresolved ref dir 271 index 6 namelen 2 name gl filetype 0 error 3                                                     
root 5 inode 279 errors 0
unresolved ref dir 271 index 7 namelen 2 name nl filetype 0 error 3                                                     
root 5 inode 280 errors 0
unresolved ref dir 271 index 8 namelen 2 name pl filetype 0 error 3                                                     
root 5 inode 281 errors 0
unresolved ref dir 271 index 9 namelen 2 name sv filetype 0 error 3                                                     
root 5 inode 290 errors 0
unresolved ref dir 272 index 2 namelen 4 name man1 filetype 0 error 3                                                   
root 5 inode 291 errors 0
unresolved ref dir 272 index 3 namelen 4 name man2 filetype 0 error 3                                                   
root 5 inode 292 errors 0
unresolved ref dir 272 index 4 namelen 4 name man3 filetype 0 error 3                                                   
root 5 inode 293 errors 0
unresolved ref dir 272 index 5 namelen 4 name man5 filetype 0 error 3                                                   
root 5 inode 316 errors 0
unresolved ref dir 353285 index 1288 namelen 28 name mwave.h.tmp-31838-1822528541 filetype 1 error 1
root 5 inode 353285 errors 200
found 14247617559 bytes used err is 1
total csum bytes: 13316736
total tree bytes: 627621888
btree space waste bytes: 174539968
file data blocks allocated: 13776285696
referenced 13445578752
Btrfs Btrfs v0.18

--------------080100080702060803050402--

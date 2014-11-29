Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f47.google.com ([209.85.216.47]:52603 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaK2OV3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Nov 2014 09:21:29 -0500
Received: by mail-qa0-f47.google.com with SMTP id s7so5442726qap.6
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Nov 2014 06:21:28 -0800 (PST)
MIME-Version: 1.0
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Sat, 29 Nov 2014 19:51:07 +0530
Message-ID: <CAH-HCWUR4QPDn=M8nchdRedzGU3DYDHC8d6YRH8-FBm6trWCJg@mail.gmail.com>
Subject: Moving contents from one subvol to another
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello. I am now taking the first steps to making my backup external
HDD in BtrFS. From
http://askubuntu.com/questions/119014/btrfs-subvolumes-vs-folders I
understand that the only difference between subvolumes and ordinary
folders is that the former can be snapshotted and independently
mounted.

But I have a question. I have two subvols test1, test2.

$ cd test1
$ dd if=/dev/urandom of=file bs=1M count=500
500+0 records in
500+0 records out
524288000 bytes (524 MB) copied, 36.2291 s, 14.5 MB/s
$ time mv file ../test2/
real    0m2.061s
user    0m0.013s
sys     0m0.459s
$ time { cp --reflink ../test2/file . && rm ../test2/file ; }
real    0m0.677s
user    0m0.022s
sys     0m0.086s
$ mkdir foo
$ time mv file foo/
real    0m0.096s
user    0m0.008s
sys     0m0.013s

It seems that mv is not CoW aware and hence is not able to create
reflinks so it is actually processing the entire file because it
thinks test2 is a different device/filesystem/partition or such. Is
this understanding correct?

So doing cp --reflink with rm is much faster. But it is still slower
than doing mv within the same subvol. Is it because of the
housekeeping with updating the metadata of the two subvols?

Methinks --reflink option should be added to mv for the above usecase.
Do people think this is useful? Why or why not?

My concern is that if somebody wants to consolidate two subvols into
one, though really only the metadata needs to be processed using
ordinary mv isn't aware of this and using cp --reflink with rm is
unnecessarily complicated, especially if it will involve multiple
files.

And it's not clear to me what it would entail to cp --reflink + rm an
entire directory tree because IIUC I'd have to handle each file
separately. Perhaps something (unnecessarily convoluted) like:

find . | while read f
do
[ -d "$f" ] && mkdir target/"$f" && touch target/"$f" -r "$f"
[ -f "$f" ] && cp -a --reflink "$f" target/ && rm "$f"
done

Again, what would happen to files which are not regular directories or files?

And why isn't --reflink given a single letter alias for cp?

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा

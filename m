Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:49418 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755006AbdBVTQg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Feb 2017 14:16:36 -0500
Received: from [10.0.0.4] ([95.171.32.30]) by mail.gmx.com (mrgmx001
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MgKUo-1d21AN1DoE-00NlLr for
 <linux-btrfs@vger.kernel.org>; Wed, 22 Feb 2017 20:16:33 +0100
Subject: Re: BTRFS critical: corrupt leaf, slot offset bad; then read-only
To: linux-btrfs@vger.kernel.org
References: <7d3cccae-4761-4799-9ceb-2735519bee8f@gmx.net>
 <0d721199-9407-ff6b-7a31-4dc5dae08e7b@gmx.net>
From: Lukas Tribus <lukyt@gmx.net>
Message-ID: <e85942b7-360c-b86c-730f-7f320971fc9a@gmx.net>
Date: Wed, 22 Feb 2017 20:16:30 +0100
MIME-Version: 1.0
In-Reply-To: <0d721199-9407-ff6b-7a31-4dc5dae08e7b@gmx.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I did a "btrfs check" (--readonly):

Summary:
589x filetype 1 errors 4, no inode ref (--> Files)
597x filetype 2 errors 4, no inode ref (--> Directories)
1183x root xxx inode YYYYYY errors 2001, no inode item, link count wrong

I looked at a handful of reported files which are verifiable via public 
MD5/SHA1 checksums and they are not corrupted, the checksum is correct.

Any hints or suggestions would be much appreciated, please see below for 
the btrfs check output (repeating lines omitted and some filenames 
redacted):

Checking filesystem on /dev/dm-9
UUID: f50f980e-7640-49c7-bf8d-20d55cfe6005
checking extents [.]
[...]
incorrect offsets 14927 14415
bad block 5242107641856

Errors found in extent allocation tree or chunk allocation
checking free space cache [.]
[...]
checking fs roots [.]
[...]
incorrect offsets 14927 14415
incorrect offsets 14927 14415
root 261 inode 127094 errors 500, file extent discount, nbytes wrong
Found file extent holes:
     start: 0, len: 499712
     unresolved ref dir 127093 index 2 namelen 24 name ABC DE Fghij 
Klmnopr.tuv filetype 1 errors 4, no inode ref
root 261 inode 127095 errors 2001, no inode item, link count wrong
     unresolved ref dir 127080 index 13 namelen 17 name 
Whateverdir123456 filetype 2 errors 4, no inode ref
root 261 inode 127097 errors 2001, no inode item, link count wrong
     unresolved ref dir 127080 index 14 namelen 12 name 
WhateverDirectory2 filetype 2 errors 4, no inode ref
root 261 inode 127099 errors 2001, no inode item, link count wrong
     unresolved ref dir 127080 index 15 namelen 11 name AnyDir filetype 
2 errors 4, no inode ref
root 261 inode 127105 errors 2001, no inode item, link count wrong
     unresolved ref dir 127080 index 16 namelen 10 name AnotherDir 
filetype 2 errors 4, no inode ref
root 261 inode 127107 errors 2001, no inode item, link count wrong
     unresolved ref dir 127080 index 17 namelen 11 name Folder11 
filetype 2 errors 4, no inode ref
root 261 inode 127112 errors 2001, no inode item, link count wrong
     unresolved ref dir 126959 index 51 namelen 11 name Folder120 
filetype 2 errors 4, no inode ref
root 261 inode 127114 errors 2001, no inode item, link count wrong
     unresolved ref dir 126146 index 40 namelen 13 name GVC-dir filetype 
2 errors 4, no inode ref
root 261 inode 127396 errors 2001, no inode item, link count wrong
     unresolved ref dir 126146 index 41 namelen 4 name G3-dir filetype 2 
errors 4, no inode ref
root 261 inode 127527 errors 2001, no inode item, link count wrong
     unresolved ref dir 126146 index 42 namelen 11 name Hello Dir 2 
filetype 2 errors 4, no inode ref
root 261 inode 127535 errors 2001, no inode item, link count wrong
     unresolved ref dir 126146 index 43 namelen 4 name Hellodir filetype 
2 errors 4, no inode ref
root 261 inode 127573 errors 2001, no inode item, link count wrong
     unresolved ref dir 126146 index 44 namelen 6 name Hello 2 filetype 
2 errors 4, no inode ref
root 261 inode 127620 errors 2001, no inode item, link count wrong
[...]
root 261 inode 177273 errors 2001, no inode item, link count wrong
     unresolved ref dir 23439 index 23 namelen 24 name Firefox Setup 
51.0.1.exe filetype 1 errors 4, no inode ref
root 261 inode 177275 errors 2001, no inode item, link count wrong
     unresolved ref dir 23439 index 26 namelen 27 name Firefox Setup 
45.7.0esr.exe filetype 1 errors 4, no inode ref
root 261 inode 180457 errors 2001, no inode item, link count wrong
[...]
checking fs roots [o]
incorrect offsets 14927 14415
checking fs roots [.]
[...]
checking fs roots [o]
The following tree block(s) is corrupted in tree 263:
     tree block bytenr: 5242107641856, level: 0, node key: 
(5241902333952, 169, 0)
checking fs roots [o]
incorrect offsets 14927 14415
checking fs roots [O]
The following tree block(s) is corrupted in tree 6685:
     tree block bytenr: 5242107641856, level: 0, node key: 
(5241902333952, 169, 0)
checking fs roots [o]
checking fs roots [.]
incorrect offsets 14927 14415
The following tree block(s) is corrupted in tree 6879:
     tree block bytenr: 5242107641856, level: 0, node key: 
(5241902333952, 169, 0)
checking fs roots [o]
incorrect offsets 14927 14415
incorrect offsets 14927 14415
root 6893 inode 127094 errors 500, file extent discount, nbytes wrong
Found file extent holes:
     start: 0, len: 499712
     unresolved ref dir 127093 index 2 namelen 24 name ABC DE Fghij 
Klmnopr.tuv filetype 1 errors 4, no inode ref
root 6893 inode 127095 errors 2001, no inode item, link count wrong
     unresolved ref dir 127080 index 13 namelen 17 name 
Whateverdir123456 filetype 2 errors 4, no inode ref
root 6893 inode 127097 errors 2001, no inode item, link count wrong
[...]
root 6893 inode 177273 errors 2001, no inode item, link count wrong
     unresolved ref dir 23439 index 23 namelen 24 name Firefox Setup 
51.0.1.exe filetype 1 errors 4, no inode ref
root 6893 inode 177275 errors 2001, no inode item, link count wrong
     unresolved ref dir 23439 index 26 namelen 27 name Firefox Setup 
45.7.0esr.exe filetype 1 errors 4, no inode ref
incorrect offsets 14927 14415
incorrect offsets 14927 14415
root 6896 inode 127094 errors 500, file extent discount, nbytes wrong
Found file extent holes:
     start: 0, len: 499712
     unresolved ref dir 127093 index 2 namelen 24 name ABC DE Fghij 
Klmnopr.tuv filetype 1 errors 4, no inode ref
root 6896 inode 127095 errors 2001, no inode item, link count wrong
     unresolved ref dir 127080 index 13 namelen 17 name 
Whateverdir123456 filetype 2 errors 4, no inode ref
root 6896 inode 127097 errors 2001, no inode item, link count wrong
[...]
root 6896 inode 177273 errors 2001, no inode item, link count wrong
     unresolved ref dir 23439 index 23 namelen 24 name Firefox Setup 
51.0.1.exe filetype 1 errors 4, no inode ref
root 6896 inode 177275 errors 2001, no inode item, link count wrong
     unresolved ref dir 23439 index 26 namelen 27 name Firefox Setup 
45.7.0esr.exe filetype 1 errors 4, no inode ref
The following tree block(s) is corrupted in tree 6893:
     tree block bytenr: 5242107641856, level: 0, node key: 
(5241902333952, 169, 0)
The following tree block(s) is corrupted in tree 6896:
     tree block bytenr: 5242107641856, level: 0, node key: 
(5241902333952, 169, 0)

found 4042079987465 bytes used err is 1
total csum bytes: 0
total tree bytes: 179142656
total fs tree bytes: 0
total extent tree bytes: 176128000
btree space waste bytes: 48203815
file data blocks allocated: 1545338880
  referenced 1545338880


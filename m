Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:33906 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751995AbdDKPLv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Apr 2017 11:11:51 -0400
Received: by mail-io0-f175.google.com with SMTP id a103so5776625ioj.1
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Apr 2017 08:11:50 -0700 (PDT)
Received: from [192.168.0.23] ([98.4.97.1])
        by smtp.gmail.com with ESMTPSA id c91sm8055017iod.18.2017.04.11.08.11.46
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 11 Apr 2017 08:11:46 -0700 (PDT)
Message-ID: <58ECF232.6010500@gmail.com>
Date: Tue, 11 Apr 2017 11:11:46 -0400
From: "J. Hart" <jfhart085@gmail.com>
Reply-To: jfhart085@gmail.com
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Unexpected: send/receive much slower than rsync ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm trying to update from an old snapshot of a directory to a new one 
using send/receive. It seems a great deal slower than I was expecting, 
perhaps much slower than rsync and has been running for hours. 
Everything looks ok with how I set up the snapshots, and there are no 
error messages, but I don't think it should be running this long. The 
directory structure is rather complex, so that may have something to do 
with it. It contains reflinked incremental backups of root file systems 
from a number of machines. It should not actually be very large due to 
the reflinks.

Sending the old version of the snapshot for the directory did not seem 
to take this long, and I expected the "send -p <old> <new>" to be much 
faster than that.

I tried running the "send" and "receive" with "-vv" to get more detail 
on what was happening.

I had thought that btrfs send/receive purely dealt with block/extent 
level changes.

I could be mistaken, but it seems that btrfs receive actually does a 
great deal of manipulation at the level of individual files, and rather 
less efficiently than rsync at that. I am not sure whether it is using 
system calls to do this, or actual shell commands themselves. I see 
quite a bit of what looks like file level manipulation in the verbose 
output. It is indeed very fast for simple directory trees even with very 
large files. However, it seems to be far slower than rsync with 
moderately complex directory trees, even if no large files are present.

I hope I'm overlooking something, and that this is not actually the 
case. Any ideas on this ?

J. Hart


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38992 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755085Ab3LST7x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Dec 2013 14:59:53 -0500
From: Chris Mason <clm@fb.com>
To: "eab@gmx.ch" <eab@gmx.ch>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs on bcache
Date: Thu, 19 Dec 2013 19:59:47 +0000
Message-ID: <1387483201.23881.2.camel@ret.masoncoding.com>
References: <CAFvEZVF8J0jbYnTtV7X6uJWL1pBkwG6iFbH-KoNSPGq0Mc7bTw@mail.gmail.com>
In-Reply-To: <CAFvEZVF8J0jbYnTtV7X6uJWL1pBkwG6iFbH-KoNSPGq0Mc7bTw@mail.gmail.com>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2013-12-18 at 18:17 +-0100, eb wrote:
+AD4- I've recently setup a system (Kernel 3.12.5-1-ARCH) which is layered as follows:
+AD4- 
+AD4- /dev/sdb3 - cache0 (80 GB Intel SSD)
+AD4- /dev/sdc1 - backing device (2 TB WD HDD)
+AD4- 
+AD4- sdb3+-sdc1 +AD0APg- /dev/bcache0
+AD4- 
+AD4- On /dev/bcache0, there's a btrfs filesystem with 2 subvolumes, mounted
+AD4- as / and /home. What's been bothering me are the following entries in
+AD4- my kernel log:
+AD4- 
+AD4- +AFs-13811.845540+AF0- incomplete page write in btrfs with offset 1536 and length 2560
+AD4- +AFs-13870.326639+AF0- incomplete page write in btrfs with offset 3072 and length 1024
+AD4- 
+AD4- The offset/length values are always either 1536/2560 or 3072/1024,
+AD4- they sum up nicely to 4K. There are 607 of those in there as I am
+AD4- writing this, the machine has been up 18 hours and been under no
+AD4- particular I/O strain (it's a desktop).

Btrfs shouldn't be setting the offset on the bios.  Are you able to add
a WARN+AF8-ON to the message that prints this so we can see the stack trace?

Could you please cc the bcache and btrfs list together?

-chris


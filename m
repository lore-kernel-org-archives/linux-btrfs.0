Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17.italiaonline.it ([212.48.25.145]:34216 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752587AbcCWTp5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Mar 2016 15:45:57 -0400
Reply-To: kreijack@inwind.it
Subject: Re: overlay file to test btrfs repairs
References: <CAJCQCtRbOa14an+UooFJYBK5JNQppYfXKHqpOfKVXHBYPAQ_Kg@mail.gmail.com>
 <pan$2fe7d$1410eb30$c926ea8c$aa8d1cf9@cox.net> <56EFD981.7020606@gmail.com>
To: linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56F2F272.5000001@inwind.it>
Date: Wed, 23 Mar 2016 20:45:54 +0100
MIME-Version: 1.0
In-Reply-To: <56EFD981.7020606@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-21 12:22, Austin S. Hemmelgarn wrote:
[...]
> If we could find some way to have the programs themselves do this if
> the system supports it (and the user opts in of course), it would be
> really helpful.  That said, I can see this possibly causing issues
> due to duplicate device UUID's. 

In the past I proposed (and implemented a prototype) of a mount.btrfs
helper [1]. The idea behind it was to collect all the action of
preparing a filesystem in only one place:

- collecting info about all the devices involved/needed
- taking the decision if a degraded filesystem has to be mounted
as degraded or an error has to be raised or continuing to wait for a new
device
- raising an error in case of conflicting uuid

Also it would be more simple to implement a logic to use an
"overlay device(s)": it could be done as option ! :-)

Now to implement these point we have to change several place (kernel, udev rules, btrfs scan utility) to got it... Not to mention that between the 
first device discovery and the filesystem mount, there would be several 
seconds due to boot process.

BR
G.Baroncelli


[1]http://marc.info/?l=linux-btrfs&m=141736989508243&w=2

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

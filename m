Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from queue01a.mail.zen.net.uk ([212.23.3.234]:47089 "EHLO
	queue01a.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbaEIIUm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 May 2014 04:20:42 -0400
Received: from [212.23.1.7] (helo=smarthost01d.mail.zen.net.uk)
	by queue01a.mail.zen.net.uk with esmtp (Exim 4.72)
	(envelope-from <david@chrestomanci.org>)
	id 1WifTq-0006pu-L2
	for linux-btrfs@vger.kernel.org; Fri, 09 May 2014 07:44:30 +0000
Received: from [82.70.68.182] (helo=www.chrestomanci.org)
	by smarthost01d.mail.zen.net.uk with esmtps (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <david@chrestomanci.org>)
	id 1WifRt-0007CG-E7
	for linux-btrfs@vger.kernel.org; Fri, 09 May 2014 08:42:29 +0100
Message-ID: <536C86DE.9090003@chrestomanci.org>
Date: Fri, 09 May 2014 08:42:22 +0100
From: David Pottage <david@chrestomanci.org>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs snapshot sizes
References: <20140507111949.GT10159@merlins.org>
In-Reply-To: <20140507111949.GT10159@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/05/14 12:19, Marc MERLIN wrote:
> So have others found a good way to have an idea about how much space is
> taken by each snapshot?
>
> I've tried quota trees, but I'm not sure how to read the output, or if it's
> correct (including the negative numbers some have mentioned). Are there
> other options?
>
> I think the main problem is that the shared data field is not working,
> making it harder to know which blocks are only used in a given snapshot.

In my understanding (devs please correct me if I am wrong), a snapshot 
is just a subvolume that happens to share a lot of data with another 
subvolume. The idea of taking regular snapshots to preserve the state of 
the filing system at a point in time is a userland concept. From the 
kernel's point of view the user has asked for a clone of a subvolume, 
and both copies are equal. What the user does with one or other clone 
after that is their affair.

This means that suppose you have a subvolume representing your home 
directory that contains around 1Gb of data, and then take daily 
snapshots, asking the kernel how big each snapshot is will not give the 
answer you expect. They all contain roughly 1Gb.

The question you should be asking, is to compare two subvolumes. (eg the 
current /home and a snapshot taken of it last week), and ask how much 
data is different between the two. Depending on how you count the "size" 
of the snapshot will be the total amount of data that is not shared, or 
just the data that is in the snapshot but not the base.

The thing is, I don't think there is an easy way to get a report of the 
amount of non shared data without walking the file-systems in both 
subvolumes and building a large data structure of inodes or suchlike.

Measuring the size of snapshots will get even more thorny when you take 
many snapshots. For example suppose you take one every hour, and you 
have just deleted a large file. All your old hourly snapshots will 
contain a reference to that large file, but the data will only be on 
disc once, so you don't want to count it's size more than once when 
considering how much of you disc is taken up by snapshots.

NB: I am not a btrfs developer, just an interested user, and lurker on 
this list.

-- 
David Pottage







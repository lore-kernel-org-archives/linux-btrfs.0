Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:54950 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaCJWnr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 18:43:47 -0400
Message-ID: <531E4055.7010207@libero.it>
Date: Mon, 10 Mar 2014 23:44:37 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, Lennart Poettering <lennart@poettering.net>
CC: systemd-devel@lists.freedesktop.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [systemd-devel] [HEADS-UP] Discoverable Partitions Spec
References: <20140307182603.GA22874@tango.0pointer.de> <531E059B.1010509@libero.it> <20140310200228.GA18268@tango.0pointer.de> <531E1EBA.1090404@fb.com>
In-Reply-To: <531E1EBA.1090404@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/10/2014 09:21 PM, Chris Mason wrote:
> On 03/10/2014 04:02 PM, Lennart Poettering wrote:
>> On Mon, 10.03.14 19:34, Goffredo Baroncelli (kreijack@libero.it) wrote:
[...]
>> I am pretty sure automatic discovery of mount points should not cover
>> the usecase where people install multiple distributions into the same
>> btrfs volume. THe automatic logic should cover the simple cases only,
>> and it sounds way over the top to support installing multiple OSes into
>> the same btrfs... I mean, people can do that, if they want to, they just
>> have to write a proper fstab, which I think is not too much too ask...
> 
> Thinking more about this, using the UUIDs does make it harder for the
> admin to roll back and forth between snapshots. This is similar to
> the multiple install idea, but the goal would be easily jumping back
> to the old one if an update failed.
> 
> I'm not against anything that makes us more flexible here, just
> trying to nail down the use case a little bit more.>

We can store the mount point in a xattr. Also we can store the snapshots relation (parent/child or real/rollback) in a xattr. During the boot a "systemd-btrfs-fstab-generator" could generate on the fly the right mounts list.



 
> -chris
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

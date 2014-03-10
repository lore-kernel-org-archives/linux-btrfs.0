Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:48633 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753206AbaCJTnb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 15:43:31 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [systemd-devel] [HEADS-UP] Discoverable Partitions Spec
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <531E059B.1010509@libero.it>
Date: Mon, 10 Mar 2014 13:43:24 -0600
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <7848AC27-EB95-4971-B3F8-4E9A3BB22415@colorremedies.com>
References: <20140307182603.GA22874@tango.0pointer.de> <531E059B.1010509@libero.it>
To: systemd-devel@lists.freedesktop.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 10, 2014, at 12:34 PM, Goffredo Baroncelli <kreijack@libero.it> wrote:

> On 03/07/2014 07:26 PM, Lennart Poettering wrote:
>> Heya!
>> 
>> Since yesterday systemd in git can now discover root, /home, /srv and
>> swap partitions automatically based on GPT type GUIDs, thus making
>> /etc/fstab unnecessary for simple setups.
>> 
>> I have now put together something like a spec describing the logic
>> behind that, and what it is good for:
> 
>> http://www.freedesktop.org/wiki/Specifications/DiscoverablePartitionsSpec/
>> 
> 
> Form the FAQ:
> <CITE>
> [...] What about automatic mounting of btrfs subvolumes to /var, /home and so on?
> 
> Doing a similar automatic discovery of btrfs subvolumes and mounting them automatically to the appropriate places is certainly desirable. We are waiting for the btrfs designers to add a per-subvolume type UUID to their disk format to make this possible. [...]
> </CITE>
> 
> Instead of relying on the subvolume UUID, why not relying to the subvolume name: it would be more simple and flexible to manage them.


We have a problem the instant the user snapshots any subvolume being mounted in this fashion. The resulting snapshot presumably would inherit the same "subvolumetypeGUID" as the parent, and it's now ambiguous which should be automounted, or how to fail.



Chris Murphy


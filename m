Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay06.libero.it ([212.52.84.110]:54894 "EHLO
	outrelay06.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbaCJSdQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 14:33:16 -0400
Message-ID: <531E059B.1010509@libero.it>
Date: Mon, 10 Mar 2014 19:34:03 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: systemd-devel@lists.freedesktop.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [systemd-devel] [HEADS-UP] Discoverable Partitions Spec
References: <20140307182603.GA22874@tango.0pointer.de>
In-Reply-To: <20140307182603.GA22874@tango.0pointer.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/07/2014 07:26 PM, Lennart Poettering wrote:
> Heya!
> 
> Since yesterday systemd in git can now discover root, /home, /srv and
> swap partitions automatically based on GPT type GUIDs, thus making
> /etc/fstab unnecessary for simple setups.
> 
> I have now put together something like a spec describing the logic
> behind that, and what it is good for:

> http://www.freedesktop.org/wiki/Specifications/DiscoverablePartitionsSpec/
> 

Form the FAQ:
<CITE>
[...] What about automatic mounting of btrfs subvolumes to /var, /home and so on?

Doing a similar automatic discovery of btrfs subvolumes and mounting them automatically to the appropriate places is certainly desirable. We are waiting for the btrfs designers to add a per-subvolume type UUID to their disk format to make this possible. [...]
</CITE>

Instead of relying on the subvolume UUID, why not relying to the subvolume name: it would be more simple and flexible to manage them.

For example supposing to use '@' as prefix for a subvolume name:

@ 	-> root filesystem
@etc	-> etc
@home 	-> home
[...]

If you want multiple OS on the same filesystem we can use the following convention

@home		-> home of all the systems
@srv		-> srv  of all the systems
@fedora_	-> root of a fedora system
@fedora_etc	-> etc of the fedora system
@fedora2_	-> root of a fedora2 system
@fedora2_etc	-> etc of the fedora2 system

Or in another way we could group the different systems in subdirectories:

@home		-> home of all the systems
@srv		-> srv  of all the systems
fedora/@	-> root of a fedora system
fedora/@etc	-> etc of the fedora system
fedora2/@	-> root of a fedora2 system
fedora2/@etc	-> etc of the fedora2 system



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

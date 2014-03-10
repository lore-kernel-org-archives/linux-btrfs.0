Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:39298 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbaCJSxu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 14:53:50 -0400
Received: by mail-wg0-f46.google.com with SMTP id b13so3018329wgh.5
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Mar 2014 11:53:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <531E059B.1010509@libero.it>
References: <20140307182603.GA22874@tango.0pointer.de> <531E059B.1010509@libero.it>
From: Kay Sievers <kay@vrfy.org>
Date: Mon, 10 Mar 2014 19:53:29 +0100
Message-ID: <CAPXgP13GbpRtxfOMjKgXcdxzOwE+phhNY+F=g8OCb_MLm4EOqQ@mail.gmail.com>
Subject: Re: [systemd-devel] [HEADS-UP] Discoverable Partitions Spec
To: kreijack@inwind.it
Cc: systemd-devel@lists.freedesktop.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 10, 2014 at 7:34 PM, Goffredo Baroncelli <kreijack@libero.it> wrote:
> On 03/07/2014 07:26 PM, Lennart Poettering wrote:

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

As a general rule: human-readable names should be left to the
administrator, provide an identifier for humans, and should not be
overloaded with magic machine behavior.

Kay

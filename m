Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29478 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbcAVF7p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jan 2016 00:59:45 -0500
Subject: Re: "Some devices missing" only while not mounted
To: Chris Murphy <lists@colorremedies.com>
References: <56A13176.2050502@gmail.com> <56A1A84A.2020801@oracle.com>
 <CAJCQCtTn8KvDRCD2h9aKBaWzYDLJpK6zE-f9AuDcD8zH4+Q_Tg@mail.gmail.com>
Cc: Konstantin Svist <fry.kun@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56A1C542.2050205@oracle.com>
Date: Fri, 22 Jan 2016 13:59:30 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTn8KvDRCD2h9aKBaWzYDLJpK6zE-f9AuDcD8zH4+Q_Tg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/22/2016 12:40 PM, Chris Murphy wrote:
> On Thu, Jan 21, 2016 at 8:55 PM, Anand Jain <anand.jain@oracle.com> wrote:
>
>>    'btrfs dev ready':
>>       - cannot be fixed without breaking the API rules.
>>       May be we would obsolete this cli to a sysfs interface or
>>       something else.
>
>
> Wait, so 'btrfs dev ready' will always exit 1 (not ready) any time a
> device has been made missing or replaced?

>  And therefore now the
> system can't boot anymore since udev+systemd won't mount a Btrfs root
> fs that's not ready? That's kindof a nasty bug.

  In the case here, its not a problem as kernel doesn't think there
  is a missing device. So with that 'btrfs dev ready' should return 0,
  unless user is providing a device which was deleted in the btrfs
  device tree but failed to wipe the SB in the deleted device.

  However there are some cases where 'btrfs dev ready' will never
  return 0, especially in the cases of seed/sprout devices. So if
  system boot depends on that, then yes boot will fail. (I am not
  sure if there are some real use cases).

  Next. Even with a missing device some pools are mountable with
  degrade option. Discussion on this before preferred boot to
  ask for the user choice. Since its alway challenging to know
  if the device is really missing OR its just +1s slower than
  our timeout in waiting for it.

Thanks, Anand



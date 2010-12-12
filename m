From: cwillu <cwillu@cwillu.com>
Subject: Re: ENOSPC on heterogeneous raid 0
Date: Sun, 12 Dec 2010 09:01:53 -0600
Message-ID: <AANLkTik6q0errBWt81tMb_kpQMO6vJi5qvPJ1NS=fu-v@mail.gmail.com>
References: <AANLkTikWrcJ+hWr0WS+1eeXdGKce3Xf-aH9k5Fg4x8Z3@mail.gmail.com>
	<201012121524.59737.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: William Sheffler <will@sheffler.me>, linux-btrfs@vger.kernel.org
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201012121524.59737.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 12, 2010 at 8:24 AM, Hubert Kario <hka@qbs.com.pl> wrote:
> On Wednesday 08 of December 2010 22:53:25 William Sheffler wrote:
>> Hello btrfs community.
>>
>> First off, thanks for all your hard work... I have been following
>> btrfs with interest for several years now and very much look forward
>> to the day it replaces ext4. The real killer feature (of btrfs
>> specifically) for me is the ability to add *and remove* devices from a
>> filesystem, as this allows rolling upgrades of my server's disks. I
>> have a 16 port 3ware 1650SE on which I have a number of small raid
>> units and it will be fantastic to be able to remove the oldest,
>> upgrade, and add the new storage back. I had previously been using
>> ZFS, but since ZFS doesn't allow removal of devices, this rolling
>> upgrade strategy doesn't work.
>>
>> My question is this: can btrfs handle striping (raid 0) across
>> heterogeneous devices? I seem to be losing any capacity on the larger
>> disk beyond what is available on the smaller disk. I really hope there
>> is some simple fix!
>
> Yes, it can handle stripping over devices of different size, unfortunately
> you're still limited to <size of smallest device>*<number of devices>
>
> if you want to use all the available space use "-d single" when creating
> volume
>
> for details, read the recent thread "800GB free, but no space left"

If I'm not mistaken, -d single doesn't mean anything yet on a
multi-device system:  you'll still get raid0.

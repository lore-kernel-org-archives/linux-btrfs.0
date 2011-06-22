From: Miguel Garrido <miguel@mjgar.com>
Subject: Re: Mounting a RAID 1 in degraded mode
Date: Wed, 22 Jun 2011 08:45:34 -0400
Message-ID: <BANLkTik14JF5Mxt7ay+wkrsNZX9c0ZadZA@mail.gmail.com>
References: <BANLkTikKNpUfGadK72tg2yq0y_G=3=v6Ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Tobias Kronawitter <tobias.kronawitter@tuhh.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTikKNpUfGadK72tg2yq0y_G=3=v6Ew@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 22, 2011 at 7:15 AM, Tobias Kronawitter
<tobias.kronawitter@tuhh.de> wrote:
>
>
> It looks like I added another device instead of replacing.
> I got the info so far from
> https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices#Creating_a_Multi-device_FS
> last paragraph.
>

Take a look a the "Replacing Failed Devices" section of that page.

It is possible if you created a brand new loop device that it was
picked up as a different disk altogether by btrfs (different unique
ID) so you need to delete the missing disk from the volume and then
rebalance.

At least that is my understanding of how it is supposed to work.

--
MG

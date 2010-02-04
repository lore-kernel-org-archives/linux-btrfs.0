From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: Btrfs Partition Reaches 'Disk Full' Early
Date: Thu, 4 Feb 2010 07:22:02 -0600
Message-ID: <26a1f7961002040522s672533d1t108ac1b6432301cb@mail.gmail.com>
References: <26a1f7961002031843t665677aeh53e5b7cc6aaab6a6@mail.gmail.com>
	 <45e1b66a1002032045m43329914uc189d50e9da26459@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Phillip Michael <oopsicrappe@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <45e1b66a1002032045m43329914uc189d50e9da26459@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 3, 2010 at 10:45 PM, Phillip Michael <oopsicrappe@gmail.com> wrote:
> On Wed, Feb 3, 2010 at 6:43 PM, Mitch Harder
> <mitch.harder@sabayonlinux.org> wrote:
>> I've been trying to get a handle on where my Btrfs partition would run
>> out of room, and I'm reaching the 'no space left' point earlier than I
>> was expecting.
>
>
> What's the output of btrfs-show?
>

# btrfs-show
Label: none  uuid: 94148ce6-91eb-4059-8780-4faee43e421b
	Total devices 1 FS bytes used 10.79GB
	devid    1 size 13.36GB used 13.36GB path /dev/sda5

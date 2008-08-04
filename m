From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: single disk reed solomon codes
Date: Mon, 04 Aug 2008 07:31:02 -0400
Message-ID: <4896E876.2030507@redhat.com>
References: <3da3b5b40807190521x35477489sc06195bb182a4561@mail.gmail.com>	 <0cb201c8e9b2$a4272b20$0a00a8c0@ALDI2>	 <1216622923.6970.19.camel@s1.crocom.com.pl>	 <3da3b5b40807210040s72fdf458g44a1fe968088586e@mail.gmail.com>	 <7fe698080807210803h3a634eddw49be677e235c1c88@mail.gmail.com> <3da3b5b40808032352t704700cbmf99245fc56bfc2bd@mail.gmail.com>
Reply-To: rwheeler@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Ahmed Kamal <email.ahmedkamal@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3da3b5b40808032352t704700cbmf99245fc56bfc2bd@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Ahmed Kamal wrote:
> An experiment of applying RS codes for protecting data, worth a look
> http://ttsiodras.googlepages.com/rsbep.html
>
> He overwrites a series of 127 sectors and still manages to correctly
> recover his data. We all know disks give us unreadable sectors every
> now and then, so at least on workstations/laptops this could really be
> useful ?
>
> Advantage over single-disk-raid1 is storage efficiency (4.2MB becomes
> 5.2MB), that means we get 80% of useable disk space, instead of 50% if
> I decide to raid1 everything ?
>
>   

This is an interesting idea and could help recover from some types of 
failures (for example, single head failures) or localized bad sectors 
(think of dust or junk on the platter).  This is almost certainly a big 
win for single disk systems. 

You would probably still need to RAID (or do other protection schemes) 
to get enterprise class data availability since you clearly cannot 
handle a full drive failure whenever you have multiple drives in a system.

Thanks!

ric


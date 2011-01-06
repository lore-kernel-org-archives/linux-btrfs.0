From: Gordan Bobic <gordan@bobich.net>
Subject: Re: Synching a Backup Server
Date: Thu, 06 Jan 2011 21:06:53 +0000
Message-ID: <4D262EED.6030809@bobich.net>
References: <201101060935.14059.CACook@quantum-sci.com>	<AANLkTi=iWyKFOoaY6JjTuhg_0CyAtOh=s2gcBUuHGwau@mail.gmail.com>	<AANLkTik-rhXAHW18id4WMMtdqXkicvzTZ47+2r6YMuY0@mail.gmail.com>	<AANLkTi=8zq-=ZG2sJBaV4JJbd-SnPpV3BQHg7dZA6Yoo@mail.gmail.com>	<AANLkTimB8vLf3_apgFc1t=7xN5ab+Sw_u8Wp2NZL=xkd@mail.gmail.com>	<AANLkTimVFkAbnkd5BDavo6fDUJ1KcOVVC=6qA6nrkySx@mail.gmail.com> <AANLkTinZXirXQtd_Fd+AN+GbWbs0Wco7dxhEz+Cg6TjO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinZXirXQtd_Fd+AN+GbWbs0Wco7dxhEz+Cg6TjO@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

>> Unfortunately, we don't use btrfs or LVM on remote servers, so there's
>> no snapshotting available during the backup run.  In a perfect world,
>> btrfs would be production-ready, ZFS would be available on Linux, and
>> we'd no longer need the abomination called LVM.  :)

As a matter of fact, ZFS _IS_ available on Linux:
http://zfs.kqinfotech.com/

Gordan

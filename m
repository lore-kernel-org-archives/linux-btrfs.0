From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: [PATCH RESEND] Btrfs: fix inaccurate available space on raid0 profile
Date: 14 Dec 2011 09:55:00 +0100
Message-ID: <BzrzJiPD1uB@helmut.hullen.de>
References: <4EE8553F.8080608@cn.fujitsu.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EE8553F.8080608@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Miao,

Du meintest am 14.12.11:

> When we use raid0 as the data profile, df command may show us a very
> inaccurate value of the available space, which may be much less than
> the real one. It may make the users puzzled. Fix it by changing the
> calculation of the available space, and making it be more similar to
> a fake chunk allocation.

Sounds very good!

Viele Gruesse!
Helmut

From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Could I create volumes on one device ?
Date: Thu, 13 Oct 2011 00:00:43 +0700
Message-ID: <CAG1y0sfETeaYKAUsdwPLE4Lb=egQs3FvDsxD3JrHf7Nr+ZGFhA@mail.gmail.com>
References: <1318438269.56248.YahooMailNeo@web74112.mail.tp2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1318438269.56248.YahooMailNeo@web74112.mail.tp2.yahoo.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 12, 2011 at 11:51 PM, bbsposters <bbsposters@yahoo.com.tw> wrote:
> Hi list,
> I want to create volumes (not subvolumes) on one device.
> Could it work?
> If it works, how can I do by btrfs tools ?
> If it can't, is there any way to create subvolumes which have their independent space?
> For example, I want to create 100MB for /home and 50 MB for /root.
> thanks,

Short version: No. For that particular purpose, currently you'd better
stick with wither LVM+ext4 or zfs.

Long version: IIRC Arne Jansen posted patches for subvolume/qgroup
quota support, so it can be used for what you need, up to a certain
degree. It's not as complete as zfs (which also supports reservation
in addition to quota), and it hasn't reached upstream kernel yet (at
least it's not in 3.1-rc9).

-- 
Fajar

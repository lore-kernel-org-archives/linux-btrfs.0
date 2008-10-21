From: "Yan Zheng" <yanzheng@21cn.com>
Subject: Re: compare COW files
Date: Tue, 21 Oct 2008 13:59:05 +0800
Message-ID: <3d0408630810202259i73d74ce6lf2682a155c1c221e@mail.gmail.com>
References: <20081021032552.2250.qmail@splitreflection.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: calin@splitreflection.com, des@condordes.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081021032552.2250.qmail@splitreflection.com>
List-ID: <linux-btrfs.vger.kernel.org>

2008/10/21 calin <calin@splitreflection.com>:
> If I make a cow copy of a file, is there a way find out whether either copy has changed?  Specifically, I'm looking for a way to figure out which files have changed since a snapshot was taken, short of traditional and time-consuming file comparisons.  It could have some interesting possibilities for monitoring and backup, to be able to quickly compare against a reference snapshot to find changes.

Btrfs disk format already supports this. We will implement this in the
near future.

Regards
Yan Zheng

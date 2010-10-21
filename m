From: Diego Calleja <diegocg@gmail.com>
Subject: Re: [PATCH] Btrfs: add support for mixed data+metadata block groups V3
Date: Fri, 22 Oct 2010 00:09:26 +0200
Message-ID: <201010220009.26464.diegocg@gmail.com>
References: <1286452263-1635-1-git-send-email-josef@redhat.com> <AANLkTi=9uDOLNk3JnLN=okVWwSZBvfpSdMwvAWkMJK0g@mail.gmail.com> <AANLkTik4xa+TKqP-4Hp2FErmbLUh0qu-ge-0qiHfBLuZ@mail.gmail.com>
Reply-To: diegocg@gmail.com
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
To: David Nicol <davidnicol@gmail.com>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTik4xa+TKqP-4Hp2FErmbLUh0qu-ge-0qiHfBLuZ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Jueves, 21 de Octubre de 2010 17:46:58 David Nicol escribi=C3=B3:
> Does this mixing constitute a forbidden change of on-disk format, and
> if not how not?

It doesn't need a format change. The difference between a data and
a metadata block group is just an allocation hint AFAIK.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

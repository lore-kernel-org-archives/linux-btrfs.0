From: David Nicol <davidnicol@gmail.com>
Subject: Re: [PATCH] Btrfs: add support for mixed data+metadata block groups V3
Date: Thu, 21 Oct 2010 10:46:58 -0500
Message-ID: <AANLkTik4xa+TKqP-4Hp2FErmbLUh0qu-ge-0qiHfBLuZ@mail.gmail.com>
References: <1286452263-1635-1-git-send-email-josef@redhat.com>
	<AANLkTi=9uDOLNk3JnLN=okVWwSZBvfpSdMwvAWkMJK0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=9uDOLNk3JnLN=okVWwSZBvfpSdMwvAWkMJK0g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Does this mixing constitute a forbidden change of on-disk format, and
if not how not?


On Wed, Oct 20, 2010 at 11:21 PM, Mitch Harder
<mitch.harder@sabayonlinux.org> wrote:
> Other than that, it seemed to perform well. =C2=A0I did not encounter=
 any
> stability issues as long as I was using a patched kernel.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

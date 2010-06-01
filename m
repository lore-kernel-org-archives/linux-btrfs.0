From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: Disk space accounting and subvolume delete
Date: Tue, 1 Jun 2010 10:32:27 +0800
Message-ID: <AANLkTinLc3_f5U_XSdWjTxfWKdKF_gZIg2HAD44u5Zti@mail.gmail.com>
References: <20100510182352.GA21154@untroubled.org>
	<AANLkTilDHeJ_aRQSKWUTJgIBhlpLHyNRTy4x4ai_MGJI@mail.gmail.com>
	<20100511154518.GA11710@untroubled.org>
	<AANLkTikzNWS11qycrI94k69PFEZJWpAezwuOF6nmw_PF@mail.gmail.com>
	<20100531190107.GA20103@untroubled.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100531190107.GA20103@untroubled.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 1, 2010 at 3:01 AM, Bruce Guenter <bruce@untroubled.org> wr=
ote:
> On Wed, May 12, 2010 at 01:02:07PM +0800, Yan, Zheng =A0wrote:
>> Dropping a tree can be lengthy. It's not good to let sync wait for h=
ours.
>> For most linux FS, 'sync' just force an transaction/journal commit. =
I don't
>> think they wait for large operations that can span multiple transact=
ions to
>> complete.
>
> What happens to the consistency of the filesystem if a crash happens
> during this process?
>

This does not break the consistency of the filesystem. Next mount will =
find the
partial dropped tree and restart the dropping process.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: Disk space accounting and subvolume delete
Date: Mon, 31 May 2010 13:34:56 -0700
Message-ID: <AANLkTilyZTk9j54i7Dzj-eeQHyWE3G5tYwzPIznDdKy1@mail.gmail.com>
References: <20100510182352.GA21154@untroubled.org>
	<AANLkTilDHeJ_aRQSKWUTJgIBhlpLHyNRTy4x4ai_MGJI@mail.gmail.com>
	<20100511154518.GA11710@untroubled.org>
	<AANLkTikzNWS11qycrI94k69PFEZJWpAezwuOF6nmw_PF@mail.gmail.com>
	<20100531190107.GA20103@untroubled.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100531190107.GA20103@untroubled.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 31, 2010 at 12:01 PM, Bruce Guenter <bruce@untroubled.org> =
wrote:
> On Wed, May 12, 2010 at 01:02:07PM +0800, Yan, Zheng =C2=A0wrote:
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

There's a good test case for you to try.  Let us know what you find.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

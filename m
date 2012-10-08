Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36573 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab2JHQqO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2012 12:46:14 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so2170500bkc.19
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Oct 2012 09:46:13 -0700 (PDT)
Message-ID: <5073035F.6000600@gmail.com>
Date: Mon, 08 Oct 2012 18:46:23 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS, getting darn slower everyday
References: <50714AC8.4010100@petaramesh.org> <loom.20121007T141248-114@post.gmane.org> <50718151.8090506@petaramesh.org> <201210071644.19815.Martin@lichtvoll.de> <5072066B.4020604@gmail.com> <50726DE1.20101@petaramesh.org> <CAJHuE_CjXaSmWRagSLxOCQpnEkpc1_S_sxSm0pVbXLiGocVA9w@mail.gmail.com> <5072F63B.5060608@petaramesh.org>
In-Reply-To: <5072F63B.5060608@petaramesh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/08/2012 05:50 PM, Swâmi Petaramesh wrote:
> Hi again Goffredo,
>
> Le 08/10/2012 13:38, Goffredo Baroncelli a écrit :
>> I fear that both the combination of autodefrag and the high number of
>> snapshot could be the root-cause of the the bad performance.
> I've removed, on one of my machines, all snapshots but three per subvol
> (keeping the oldests and newest), going from about 30 per subvol to 3,
> for the complete filesystem from 120+ to about a dozen.
>
> Then I let btrfs-cleaner do its job
>
> After that the machine boots to GUI in a bit less than 2 minutes, where
> it was more than 4 minutes previously.
>
> The machine now seems much more reactive and swift.
>
> So it seems that the number or active snapshots (or is it the number of
> subvols whatsoever ??) dramatically impacts performance...

Does the autodefrag options still alive ?
I believe that the snapshot is quite cheap, except if you update the 
shared files one at time. Which should be the case of the autodefrag.
But it is only a my supposition....

Could you please try to avoid the autodefrag option in a machine with an 
high number of snapshot ? I am curios...



>
> Thanks for the suggestion.
>


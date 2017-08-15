Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39066 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751601AbdHOSOP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Aug 2017 14:14:15 -0400
Subject: Re: btrfs-progs-v4.12: cross compiling
From: Eric Sandeen <sandeen@redhat.com>
To: dsterba@suse.cz, Hallo32 <Hallo32@gmx.net>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, kreijack@inwind.it,
        linux-btrfs@vger.kernel.org
References: <e8d480c6-758e-0e7d-a024-e9d12d7bf852@gmx.net>
 <20170814130608.GS2866@twin.jikos.cz>
 <46edbc7c-8bd9-0507-950e-be5182356772@gmx.com>
 <20170814140341.GU2866@suse.cz>
 <159b3db0-6eae-7cff-d166-3c4b0c2513ac@gmx.com>
 <20170814151052.GV2866@twin.jikos.cz>
 <340e3677-4abd-5390-58bb-a64160a31862@libero.it>
 <880007a9-4882-e4a6-7411-a262e5296ab0@gmx.com>
 <082833d5-8f2a-6ed6-fa22-042a161a0dec@gmx.net>
 <20170815124807.GZ2866@twin.jikos.cz>
 <0f50ee70-d546-6aff-b57d-1283eadefa15@redhat.com>
Message-ID: <3dc8da90-9b37-7e8d-ad8e-0096f25baf10@redhat.com>
Date: Tue, 15 Aug 2017 13:14:14 -0500
MIME-Version: 1.0
In-Reply-To: <0f50ee70-d546-6aff-b57d-1283eadefa15@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/15/17 12:28 PM, Eric Sandeen wrote:
> I guess it's harder to do in btrfs-progs since it's not using autotools...

Eh, I don't know why I thought that was still true :)  patch sent.

-Eric

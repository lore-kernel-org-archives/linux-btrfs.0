Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:54721 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751382AbdJPAvK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Oct 2017 20:51:10 -0400
Subject: Re: Why isnt NOCOW attributes propogated on snapshot transfers?
To: Cerem Cem ASLAN <ceremcem@ceremcem.net>, linux-btrfs@vger.kernel.org
References: <CAN4oSBcZmqh+iK7Qyd4VBcOhQDfZVAu2B7_1pL60UKCb_oX3zg@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f7d452b4-8607-bef4-6e3c-c96bde726541@gmx.com>
Date: Mon, 16 Oct 2017 08:51:04 +0800
MIME-Version: 1.0
In-Reply-To: <CAN4oSBcZmqh+iK7Qyd4VBcOhQDfZVAu2B7_1pL60UKCb_oX3zg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年10月15日 09:19, Cerem Cem ASLAN wrote:
> `btrfs send | btrfs receive` removes NOCOW attributes. Is it a bug or
> a feature? If it's a feature, how can we keep these attributes if we
> need to?

It seems that, current send doesn't have support for extra inode flags.

Send can only send out c/m/atime, uid/gid and xattr.

Since NODATACOW is stored in inode item flags, not xattr, so it's not 
supported yet.

Thanks,
Qu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

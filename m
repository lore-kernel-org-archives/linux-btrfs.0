Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from titan.hyper.fi ([80.83.3.82]:53901 "EHLO titan.hyper.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752361AbdI0I0z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 04:26:55 -0400
Received: from localhost (localhost [127.0.0.1])
        by titan.hyper.fi (Postfix) with ESMTP id 503BAE7D5B
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 11:26:52 +0300 (EEST)
Date: Wed, 27 Sep 2017 11:26:52 +0300 (EEST)
From: Ari Saastamoinen <linux-btrfs@oh3mqu.pp.hyper.fi>
To: linux-btrfs@vger.kernel.org
Subject: Re: Wrong device?
In-Reply-To: <pan$ac76f$d1873c6f$99e25eaa$74646ca8@cox.net>
Message-ID: <alpine.LFD.2.00.1709271117270.25674@titan.hyper.fi>
References: <cdca7f92-93c0-9906-f2ed-57c3d0a97fae@jp.fujitsu.com>        <3b6d4951-dd71-989d-3287-12ffe643bfae@suse.com>        <b1b5a231-ffc3-700b-b59d-e82accf2f2e7@rqc.ru>        <095397b6-4865-1ea3-ae0d-6725b84c447c@gmx.com>        <20170925075250.GC25529@carfax.org.uk>
        <7a345608-6c5d-bdc9-9b5f-74a8052ea228@gmx.com>        <20170925141951.GD25529@carfax.org.uk>        <d0e2c24a-c6c6-c154-c8ad-d37fdea669d5@gmx.com>        <345d459f-0d32-0ff9-19d3-86f86f165dfe@rqc.ru>        <alpine.LFD.2.00.1709251835060.25674@titan.hyper.fi>
 <pan$ac76f$d1873c6f$99e25eaa$74646ca8@cox.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 26 Sep 2017, Duncan wrote:

> consider it worth having.  No backups means you are defining the data to
> be of less value than the time/trouble/resources to make the backup, so
> loss is never a big deal, because either you either have a backup if you

I know importance of backups, and this problematic machine are backups  (I 
still have originals if this crashes)

> That's why btrfs is listing one of the md components as part of the
> filesystem -- it obviously has the same btrfs UUID as the md device that
> you actually created the filesystem on.

# for I in c d e f g h i j k l n o p q r ; do blkid /dev/sd$I ; done ; blkid /dev/md3
/dev/sdc: UUID="d68e26ee-baeb-f40d-c579-2d506e18d378" UUID_SUB="cffdd56f-f8d6-5191-bd7b-d528018e1106" LABEL="dyn-50:3" TYPE="linux_raid_member"
/dev/sdd: UUID="d68e26ee-baeb-f40d-c579-2d506e18d378" UUID_SUB="5d586780-d22f-a68b-769a-5c1bfe9491fb" LABEL="dyn-50:3" TYPE="linux_raid_member"
/dev/sde: UUID="d68e26ee-baeb-f40d-c579-2d506e18d378" UUID_SUB="5777fb6a-7156-3a70-5384-789ac8dd5656" LABEL="dyn-50:3" TYPE="linux_raid_member"
/dev/sdf: UUID="d68e26ee-baeb-f40d-c579-2d506e18d378" UUID_SUB="f017f1c7-df26-9279-ccb9-002b8ce1edd9" LABEL="dyn-50:3" TYPE="linux_raid_member"
/dev/sdg: UUID="d68e26ee-baeb-f40d-c579-2d506e18d378" UUID_SUB="0de626d7-f754-e53b-792b-3217f6cb63d2" LABEL="dyn-50:3" TYPE="linux_raid_member"
/dev/sdh: UUID="d68e26ee-baeb-f40d-c579-2d506e18d378" UUID_SUB="036e8679-2c6f-4a48-601e-1379cdd0a3eb" LABEL="dyn-50:3" TYPE="linux_raid_member"
/dev/sdi: UUID="d68e26ee-baeb-f40d-c579-2d506e18d378" UUID_SUB="f9cb6c12-dc73-92b9-363c-fafb5b0efc81" LABEL="dyn-50:3" TYPE="linux_raid_member"
/dev/sdj: UUID="d68e26ee-baeb-f40d-c579-2d506e18d378" UUID_SUB="7f3f09d8-d09d-c263-b292-a9d5d004c7ce" LABEL="dyn-50:3" TYPE="linux_raid_member"
/dev/sdk: UUID="d68e26ee-baeb-f40d-c579-2d506e18d378" UUID_SUB="07bde9df-8f5b-518d-78fa-3cff3a950eb4" LABEL="dyn-50:3" TYPE="linux_raid_member"
/dev/sdl: UUID="d68e26ee-baeb-f40d-c579-2d506e18d378" UUID_SUB="1895c727-e8b2-463a-4f67-e260ee6e98ff" LABEL="dyn-50:3" TYPE="linux_raid_member"
/dev/sdn: UUID="d68e26ee-baeb-f40d-c579-2d506e18d378" UUID_SUB="72a6d25c-a7c0-3329-5f15-8abb7c3edbdb" LABEL="dyn-50:3" TYPE="linux_raid_member"
/dev/sdo: UUID="d68e26ee-baeb-f40d-c579-2d506e18d378" UUID_SUB="3580f74a-1605-3e5e-9396-9e929eaeb6fc" LABEL="dyn-50:3" TYPE="linux_raid_member"
/dev/sdp: UUID="d68e26ee-baeb-f40d-c579-2d506e18d378" UUID_SUB="006883cb-76f6-2967-1a5a-225d258d72b0" LABEL="dyn-50:3" TYPE="linux_raid_member"
/dev/sdq: UUID="d68e26ee-baeb-f40d-c579-2d506e18d378" UUID_SUB="b72b2bc3-d983-ed27-f64a-fea9b27e42bf" LABEL="dyn-50:3" TYPE="linux_raid_member"
/dev/sdr: UUID="d68e26ee-baeb-f40d-c579-2d506e18d378" UUID_SUB="bd7b687d-2882-3709-abe4-03f1a1010a67" LABEL="dyn-50:3" TYPE="linux_raid_member"
/dev/md3: UUID="84a31ba6-d22d-4653-b071-5525dbdfe561" UUID_SUB="36cf435b-e589-45dd-99a5-5efdb1439913" TYPE="btrfs"

Those sd* devices are member of md, and seems they aren't equal with that
md-device

-- 
Ari Saastamoinen

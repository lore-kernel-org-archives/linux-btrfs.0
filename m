Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43246 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791AbcB1A4R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Feb 2016 19:56:17 -0500
Date: Sat, 27 Feb 2016 16:56:14 -0800
From: Marc MERLIN <marc@merlins.org>
To: Anand Jain <anand.jain@oracle.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs check --repair is clean, but mount fails
Message-ID: <20160228005614.GP19699@merlins.org>
References: <20160227023938.GB5286@merlins.org>
 <20160227024533.GB11954@localhost.localdomain>
 <20160227030304.GC5286@merlins.org>
 <56D229F8.5080002@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56D229F8.5080002@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 28, 2016 at 06:58:00AM +0800, Anand Jain wrote:
>   Can you log the output of blkid here. If blkid output does
>   not report all the btrfs devs correctly the kernel won't know
>   as well.

Sure. The relevant entries are at the bottom (last 3 lines).
It looks good now of course, but I how it would have been before I ran a btrfs dev scan

Is there anything helpful in there?

/dev/sdc2: UUID="d9a11ed8-536b-e2d7-2b63-6e45318e24d6" UUID_SUB="c8b717b3-d1bb-9211-f5fd-88b4cad3891a" LABEL="gargamel.svh.merlins.org:12" TYPE="linux_raid_member" PARTUUID="fc061e12-02"
/dev/sdc3: UUID="d98cdbd0-4879-0342-1cb9-3a199281d756" UUID_SUB="c33a26df-abca-4bb2-8064-741d05334129" LABEL="gargamel.svh.merlins.org:13" TYPE="linux_raid_member" PARTUUID="fc061e12-03"
/dev/sdc4: UUID="1a134ab6-0e02-43fa-8704-deed85998155" TYPE="crypto_LUKS" PARTUUID="fc061e12-04"
/dev/sde1: UUID="0d2b91aa-3c93-54d1-5bca-28c1f96f9def" UUID_SUB="d10f45f6-52e0-d793-f3e3-b687251a83f5" LABEL="gargamel.svh.merlins.org:8" TYPE="linux_raid_member" PARTUUID="5bd72031-01"
/dev/sdf1: UUID="0d2b91aa-3c93-54d1-5bca-28c1f96f9def" UUID_SUB="aee9d2d4-bb18-579a-28f4-f6b15f89a40a" LABEL="gargamel.svh.merlins.org:8" TYPE="linux_raid_member" PARTUUID="23f4b9f6-01"
/dev/sdd1: UUID="0d2b91aa-3c93-54d1-5bca-28c1f96f9def" UUID_SUB="db2df41e-1daf-02af-89ed-6e77813e29da" LABEL="gargamel.svh.merlins.org:8" TYPE="linux_raid_member" PARTUUID="90f15dcd-01"
/dev/sda1: UUID="0d2b91aa-3c93-54d1-5bca-28c1f96f9def" UUID_SUB="00d115df-f27d-9293-6048-7af099602670" LABEL="gargamel.svh.merlins.org:8" TYPE="linux_raid_member" PARTUUID="06a7af4a-01"
/dev/sdg1: UUID="66bccdfb-afbf-9683-fcf1-f12ef2af2dcb" UUID_SUB="ca4598ba-de58-5baa-b993-5222e06ac97d" LABEL="gargamel.svh.merlins.org:6" TYPE="linux_raid_member" PARTLABEL="primary" PARTUUID="bd9db056-9d37-4191-9bd1-353b6a47b487"
/dev/sdh1: UUID="284ccdd7-5516-4ff2-b798-3bc1829c9a04" TYPE="crypto_LUKS" PARTUUID="ca3bb5a5-01"
/dev/sdh2: UUID="7be7e175-8f4c-4f99-94b2-9c904d227045" TYPE="bcache" PARTUUID="ca3bb5a5-02"
/dev/sdj1: UUID="ec672af7-a66d-9557-2f00-d76c38c9f705" UUID_SUB="684b477c-81a8-6ce9-222b-1d385aab485c" LABEL="gargamel.svh.merlins.org:5" TYPE="linux_raid_member" PARTLABEL="primary" PARTUUID="6834173c-d6a9-4da1-8de0-ddf2411557e3"
/dev/sdk1: UUID="ec672af7-a66d-9557-2f00-d76c38c9f705" UUID_SUB="7d311e9f-6747-24a5-c962-9fb63739a6e8" LABEL="gargamel.svh.merlins.org:5" TYPE="linux_raid_member" PARTLABEL="primary" PARTUUID="16d76002-b9f1-4016-8119-a200ec16d4a2"
/dev/sdl1: UUID="ec672af7-a66d-9557-2f00-d76c38c9f705" UUID_SUB="cdef3e24-371c-c5d4-a289-16dd0939eff6" LABEL="gargamel.svh.merlins.org:5" TYPE="linux_raid_member" PARTLABEL="primary" PARTUUID="8b79953b-9f6b-4649-a526-2c61fe07a6f1"
/dev/sdm1: UUID="ec672af7-a66d-9557-2f00-d76c38c9f705" UUID_SUB="075571ff-4115-17e9-027f-8c2fcef0457a" LABEL="gargamel.svh.merlins.org:5" TYPE="linux_raid_member" PARTLABEL="primary" PARTUUID="dd673133-e1a9-46dc-a42b-1554a44a9b28"
/dev/sdi1: UUID="ec672af7-a66d-9557-2f00-d76c38c9f705" UUID_SUB="02eae0f6-af27-0529-1d77-09483114b540" LABEL="gargamel.svh.merlins.org:5" TYPE="linux_raid_member" PARTLABEL="primary" PARTUUID="03d0f2a3-45a4-4172-81e2-1afad7e06d10"
/dev/sdo1: UUID="66bccdfb-afbf-9683-fcf1-f12ef2af2dcb" UUID_SUB="e8bf196a-9a58-f8de-9472-6f16ab4599d9" LABEL="gargamel.svh.merlins.org:6" TYPE="linux_raid_member" PARTLABEL="primary" PARTUUID="97573ae8-878b-41bc-b838-e0ea97a54a1b"
/dev/sdn1: UUID="a9bdc59b-51e9-c58e-58d7-48c43de9f367" TYPE="linux_raid_member" PARTUUID="911f14a9-01"
/dev/sdn2: UUID="d9a11ed8-536b-e2d7-2b63-6e45318e24d6" UUID_SUB="d2d23610-d966-dfcb-92c5-b49a3a161964" LABEL="gargamel.svh.merlins.org:12" TYPE="linux_raid_member" PARTUUID="911f14a9-02"
/dev/sdn3: UUID="d98cdbd0-4879-0342-1cb9-3a199281d756" UUID_SUB="9c50a539-3923-840a-e720-66b23d823cc2" LABEL="gargamel.svh.merlins.org:13" TYPE="linux_raid_member" PARTUUID="911f14a9-03"
/dev/sdn4: UUID="01ed40a3-a9f2-4d7d-af14-d57035a5ed55" TYPE="crypto_LUKS" PARTUUID="911f14a9-04"
/dev/sdp1: UUID="66bccdfb-afbf-9683-fcf1-f12ef2af2dcb" UUID_SUB="4910400c-8e3e-0d32-fdb9-16f8f7ca5f87" LABEL="gargamel.svh.merlins.org:6" TYPE="linux_raid_member" PARTLABEL="primary" PARTUUID="1bd91aa4-7f0e-4574-9c0e-630c2de9295f"
/dev/sdq1: UUID="66bccdfb-afbf-9683-fcf1-f12ef2af2dcb" UUID_SUB="497a9a28-4059-842b-25e2-ab31c6d48ded" LABEL="gargamel.svh.merlins.org:6" TYPE="linux_raid_member" PARTLABEL="primary" PARTUUID="84740d8d-7689-499f-9171-7d0acf8154b7"
/dev/sdr1: UUID="66bccdfb-afbf-9683-fcf1-f12ef2af2dcb" UUID_SUB="1e3ab905-ba67-7efe-2aaf-cf0d99276e26" LABEL="gargamel.svh.merlins.org:6" TYPE="linux_raid_member" PARTLABEL="primary" PARTUUID="47aa6022-6a58-4856-87d8-5c4f54212b37"
/dev/md11: UUID="6e06a918-80dc-4f00-8cd3-234939d7172d" TYPE="ext4" PTTYPE="dos"
/dev/md13: UUID="e90613ef-e719-4396-97d2-93ca62c17736" TYPE="crypto_LUKS"
/dev/md5: UUID="2b8cf5be-d74f-43fa-aebd-fed79ba5cb50" TYPE="bcache"
/dev/md6: UUID="ae32d57e-12c3-457a-bc17-4166aa6dde75" TYPE="crypto_LUKS"
/dev/md8: UUID="33b49001-7253-40b3-b617-ea91850a69d9" TYPE="crypto_LUKS"
/dev/bcache0: UUID="c02da1dc-f62b-4232-a0ed-264dae65f16a" TYPE="crypto_LUKS"
/dev/mapper/dshelf1b: UUID="47cf2391-1942-46d1-9690-d597e860a5c6" TYPE="bcache"
/dev/mapper/dshelf2: LABEL="dshelf2" UUID="d4a51178-c1e6-4219-95ab-5c5864695bfd" UUID_SUB="4f46aa7b-23a5-4ad8-8b74-d735d7caf156" TYPE="btrfs"
/dev/mapper/eswap1: UUID="b061e3e6-e775-4cdf-ab2b-1a27ac985888" TYPE="swap"
/dev/mapper/cache1: UUID="16dbdda5-46da-43ef-ac6a-6b81eaed3bb2" TYPE="bcache"
/dev/mapper/oldds1: UUID="79974649-f771-498c-8477-10d076ec3627" UUID_SUB="462789c1-b339-44ba-a53a-a96680e94ac8" TYPE="btrfs"
/dev/mapper/raid0d1: LABEL="btrfs_space" UUID="01334b81-c0db-4e80-92e4-cac4da867651" UUID_SUB="a87c0954-e0d5-4cdb-acb9-05ed290c16df" TYPE="btrfs"
/dev/mapper/raid0d2: LABEL="btrfs_space" UUID="01334b81-c0db-4e80-92e4-cac4da867651" UUID_SUB="b4ea90fa-4262-489a-830d-3bd4e7518ff2" TYPE="btrfs"
/dev/bcache1: LABEL="dshelf1" UUID="5d0847f8-b243-494a-9e31-0a7c9adbd764" UUID_SUB="f65c681d-f1a1-45f1-a2b5-290358fd9b39" TYPE="btrfs"

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

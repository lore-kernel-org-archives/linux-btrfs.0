Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E680C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 15:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03E2B207E0
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 15:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfBVPRO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 10:17:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:40584 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726582AbfBVPRO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 10:17:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 26AF8AEB3
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 15:17:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7FFA6DAA56; Fri, 22 Feb 2019 16:18:33 +0100 (CET)
Date:   Fri, 22 Feb 2019 16:18:33 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5.1 00/12] btrfs: Enhancement to tree block validation
Message-ID: <20190222151832.GG9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190218052753.24138-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190218052753.24138-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 18, 2019 at 01:27:41PM +0800, Qu Wenruo wrote:
> v5.1:
> - Add "block=%llu " output for write/read time error line.
> - Also output read time error message for fsid/start/level check.

I see reports from tests btrfs/124 and btrfs/125, the tested branch was
for-next-20190220. Something's wrong, check the large numbers of
checksums from the messages, eg.

hex(506381209866536711) = 0x707070707070707
hex(217020518514230019) = 0x303030303030303
hex(1085102592571150095) = 0xf0f0f0f0f0f0f0f
hex(72340172838076673) = 0x101010101010101

there's a pattern. And the number of the 'read time' messages is quite
high to be some random fluke.

[ 2847.704946] BTRFS: device fsid 8b8c51ce-59de-439f-847a-bcfce3e10a5d devid 1 transid 7 /dev/vdb
[ 2847.710386] BTRFS info (device vdb): allowing degraded mounts
[ 2847.713405] BTRFS info (device vdb): disk space caching is enabled
[ 2847.716586] BTRFS info (device vdb): has skinny extents
[ 2847.753599] BTRFS warning (device vdb): devid 2 uuid 307c73fe-349e-4b34-8233-4e35431aae31 is missing
[ 2847.758479] BTRFS warning (device vdb): devid 2 uuid 307c73fe-349e-4b34-8233-4e35431aae31 is missing
[ 2859.881984] BTRFS: device fsid e4579131-1621-417b-8464-cfaf6cd15204 devid 1 transid 241 /dev/vda
[ 2859.896416] BTRFS info (device vdb): disk space caching is enabled
[ 2859.899049] BTRFS info (device vdb): has skinny extents
[ 2859.992305] BTRFS error (device vdb): bad tree block start, want 32161792 have 0
[ 2859.996611] BTRFS error (device vdb): block=32161792 read time tree block corruption detected
[ 2860.001694] BTRFS info (device vdb): read error corrected: ino 0 off 32161792 (dev /dev/vdc sector 21856)                                                                                                   
[ 2860.007079] BTRFS info (device vdb): read error corrected: ino 0 off 32165888 (dev /dev/vdc sector 21864)                                                                                                   
[ 2860.012447] BTRFS info (device vdb): read error corrected: ino 0 off 32169984 (dev /dev/vdc sector 21872)                                                                                                   
[ 2860.017817] BTRFS info (device vdb): read error corrected: ino 0 off 32174080 (dev /dev/vdc sector 21880)                                                                                                   
[ 2860.023669] BTRFS error (device vdb): bad tree block start, want 32243712 have 0
[ 2860.027865] BTRFS error (device vdb): block=32243712 read time tree block corruption detected
[ 2860.032961] BTRFS info (device vdb): read error corrected: ino 0 off 32243712 (dev /dev/vdc sector 22016)                                                                                                   
[ 2860.037602] BTRFS info (device vdb): read error corrected: ino 0 off 32247808 (dev /dev/vdc sector 22024)                                                                                                   
[ 2860.042185] BTRFS info (device vdb): read error corrected: ino 0 off 32251904 (dev /dev/vdc sector 22032)                                                                                                   
[ 2860.046738] BTRFS info (device vdb): read error corrected: ino 0 off 32256000 (dev /dev/vdc sector 22040)                                                                                                   
[ 2860.089197] BTRFS info (device vdb): balance: start -d -m -s
[ 2860.092227] BTRFS info (device vdb): relocating block group 2479882240 flags data
[ 2860.098064] BTRFS error (device vdb): bad tree block start, want 31653888 have 0
[ 2860.102289] BTRFS error (device vdb): block=31653888 read time tree block corruption detected
[ 2860.107409] BTRFS info (device vdb): read error corrected: ino 0 off 31653888 (dev /dev/vdc sector 20864)                                                                                                   
[ 2860.111997] BTRFS info (device vdb): read error corrected: ino 0 off 31657984 (dev /dev/vdc sector 20872)                                                                                                   
[ 2860.166451] BTRFS error (device vdb): bad tree block start, want 31670272 have 0
[ 2860.167172] BTRFS error (device vdb): bad tree block start, want 31686656 have 0
[ 2860.167375] BTRFS error (device vdb): bad tree block start, want 31703040 have 0
[ 2860.167377] BTRFS error (device vdb): block=31703040 read time tree block corruption detected
[ 2860.167384] BTRFS error (device vdb): bad tree block start, want 31719424 have 0
[ 2860.167386] BTRFS error (device vdb): block=31719424 read time tree block corruption detected
[ 2860.167394] BTRFS error (device vdb): bad tree block start, want 31735808 have 0
[ 2860.167396] BTRFS error (device vdb): block=31735808 read time tree block corruption detected
[ 2860.170120] BTRFS error (device vdb): block=31670272 read time tree block corruption detected
[ 2860.174308] BTRFS error (device vdb): block=31686656 read time tree block corruption detected
[ 2860.205288] BTRFS error (device vdb): bad tree block start, want 31686656 have 0
[ 2860.208875] BTRFS error (device vdb): block=31686656 read time tree block corruption detected
[ 2860.244462] BTRFS error (device vdb): bad tree block start, want 31703040 have 0
[ 2860.248013] BTRFS error (device vdb): block=31703040 read time tree block corruption detected
[ 2860.284017] BTRFS error (device vdb): block=31719424 read time tree block corruption detected
[ 2860.315705] BTRFS error (device vdb): block=31735808 read time tree block corruption detected
[ 2860.336001] BTRFS error (device vdb): block=31752192 read time tree block corruption detected
[ 2860.336054] BTRFS error (device vdb): block=31768576 read time tree block corruption detected
[ 2860.339786] BTRFS error (device vdb): block=31784960 read time tree block corruption detected
[ 2860.366693] BTRFS error (device vdb): block=31768576 read time tree block corruption detected
[ 2860.389495] BTRFS error (device vdb): block=31784960 read time tree block corruption detected
[ 2860.418551] BTRFS error (device vdb): block=31866880 read time tree block corruption detected
[ 2860.418713] BTRFS error (device vdb): block=31883264 read time tree block corruption detected
[ 2860.418721] BTRFS error (device vdb): block=31916032 read time tree block corruption detected
[ 2860.418736] BTRFS error (device vdb): block=31932416 read time tree block corruption detected
[ 2860.418744] BTRFS error (device vdb): block=31948800 read time tree block corruption detected
[ 2860.419721] BTRFS error (device vdb): block=31899648 read time tree block corruption detected
[ 2860.462401] BTRFS error (device vdb): block=31866880 read time tree block corruption detected
[ 2860.490821] BTRFS error (device vdb): block=31932416 read time tree block corruption detected
[ 2860.506718] BTRFS error (device vdb): block=31899648 read time tree block corruption detected
[ 2860.535013] BTRFS error (device vdb): block=31916032 read time tree block corruption detected
[ 2860.568602] BTRFS error (device vdb): block=31948800 read time tree block corruption detected
[ 2860.590434] BTRFS error (device vdb): block=31965184 read time tree block corruption detected
[ 2860.590532] BTRFS error (device vdb): block=31981568 read time tree block corruption detected
[ 2860.590677] BTRFS error (device vdb): block=31997952 read time tree block corruption detected
[ 2860.590688] BTRFS error (device vdb): block=32014336 read time tree block corruption detected

[ 2860.590697] BTRFS error (device vdb): block=32030720 read time tree block corruption detected
[ 2860.590705] BTRFS error (device vdb): block=32047104 read time tree block corruption detected
[ 2860.625834] BTRFS error (device vdb): block=31965184 read time tree block corruption detected
[ 2860.658723] BTRFS error (device vdb): block=31981568 read time tree block corruption detected
[ 2860.696644] BTRFS error (device vdb): block=32014336 read time tree block corruption detected
[ 2860.735014] BTRFS error (device vdb): block=32030720 read time tree block corruption detected
[ 2860.743240] BTRFS error (device vdb): block=32096256 read time tree block corruption detected
[ 2860.780296] BTRFS error (device vdb): block=32047104 read time tree block corruption detected
[ 2860.807073] BTRFS error (device vdb): block=32063488 read time tree block corruption detected
[ 2860.807173] BTRFS error (device vdb): block=32079872 read time tree block corruption detected
[ 2860.841582] BTRFS error (device vdb): block=32079872 read time tree block corruption detected
[ 2862.476657] BTRFS info (device vdb): found 3 extents
[ 2864.186610] BTRFS info (device vdb): found 3 extents
[ 2864.190233] BTRFS error (device vdb): block=31637504 read time tree block corruption detected
[ 2864.306413] BTRFS info (device vdb): relocating block group 2446327808 flags system
[ 2864.418449] BTRFS info (device vdb): relocating block group 2177892352 flags metadata
[ 2864.530002] BTRFS info (device vdb): relocating block group 1104150528 flags data|raid1
[ 2864.582024] BTRFS warning (device vdb): csum failed root -9 ino 260 off 2097152 csum 0x6e65c49f expected csum 0x98f94189 mirror 1                                                                           
[ 2864.582156] BTRFS warning (device vdb): csum failed root -9 ino 260 off 2162688 csum 0x5ce6193f expected csum 0x98f94189 mirror 1                                                                           
[ 2864.587210] BTRFS warning (device vdb): csum failed root -9 ino 260 off 2101248 csum 0x6e65c49f expected csum 0x98f94189 mirror 1                                                                           
[ 2864.594057] BTRFS warning (device vdb): csum failed root -9 ino 260 off 2228224 csum 0x89780ae9 expected csum 0x98f94189 mirror 1                                                                           
[ 2864.594156] BTRFS warning (device vdb): csum failed root -9 ino 260 off 2359296 csum 0xfd497142 expected csum 0x98f94189 mirror 1                                                                           
[ 2864.594200] BTRFS warning (device vdb): csum failed root -9 ino 260 off 2363392 csum 0xfd497142 expected csum 0x98f94189 mirror 1                                                                           
[ 2864.594228] BTRFS warning (device vdb): csum failed root -9 ino 260 off 2367488 csum 0xfd497142 expected csum 0x98f94189 mirror 1                                                                           
[ 2864.594267] BTRFS warning (device vdb): csum failed root -9 ino 260 off 2371584 csum 0xfd497142 expected csum 0x98f94189 mirror 1                                                                           
[ 2864.594291] BTRFS warning (device vdb): csum failed root -9 ino 260 off 2490368 csum 0xddddd09d expected csum 0x98f94189 mirror 1                                                                           
[ 2864.594294] BTRFS warning (device vdb): csum failed root -9 ino 260 off 2375680 csum 0xfd497142 expected csum 0x98f94189 mirror 1                                                                           
[ 2864.686125] BTRFS error (device vdb): parent transid verify failed on 30539776 wanted 8 found 5
[ 2864.859090] BTRFS error (device vdb): parent transid verify failed on 30556160 wanted 8 found 5
[ 2864.936897] BTRFS error (device vdb): parent transid verify failed on 30572544 wanted 8 found 6
[ 2865.003123] repair_io_failure: 5828 callbacks suppressed
[ 2865.003127] BTRFS info (device vdb): read error corrected: ino 260 off 43462656 (dev /dev/vdc sector 2200472)                                                                                               
[ 2865.003141] BTRFS info (device vdb): read error corrected: ino 260 off 43683840 (dev /dev/vdc sector 2200904)                                                                                               
[ 2865.003210] BTRFS info (device vdb): read error corrected: ino 260 off 43659264 (dev /dev/vdc sector 2200856)                                                                                               
[ 2865.003223] BTRFS info (device vdb): read error corrected: ino 260 off 43651072 (dev /dev/vdc sector 2200840)                                                                                               
[ 2865.005980] BTRFS info (device vdb): read error corrected: ino 260 off 43663360 (dev /dev/vdc sector 2200864)                                                                                               
[ 2865.006063] BTRFS info (device vdb): read error corrected: ino 260 off 43446272 (dev /dev/vdc sector 2200440)                                                                                               
[ 2865.006098] BTRFS info (device vdb): read error corrected: ino 260 off 43638784 (dev /dev/vdc sector 2200816)                                                                                               
[ 2865.010374] BTRFS info (device vdb): read error corrected: ino 260 off 43655168 (dev /dev/vdc sector 2200848)                                                                                               
[ 2865.010425] BTRFS info (device vdb): read error corrected: ino 260 off 43700224 (dev /dev/vdc sector 2200936)                                                                                               
[ 2865.010664] BTRFS info (device vdb): read error corrected: ino 260 off 43843584 (dev /dev/vdc sector 2201216)                                                                                               
[ 2865.112654] BTRFS error (device vdb): parent transid verify failed on 30588928 wanted 8 found 6
[ 2865.267513] btree_readpage_end_io_hook: 34 callbacks suppressed
[ 2865.267518] BTRFS error (device vdb): bad tree block start, want 30670848 have 0
[ 2865.267544] BTRFS error (device vdb): bad tree block start, want 30687232 have 0
[ 2865.267549] BTRFS error (device vdb): bad tree block start, want 30703616 have 0
[ 2865.267551] BTRFS error (device vdb): block=30703616 read time tree block corruption detected
[ 2865.267578] BTRFS error (device vdb): bad tree block start, want 30736384 have 0
[ 2865.267580] BTRFS error (device vdb): block=30736384 read time tree block corruption detected
[ 2865.267823] BTRFS error (device vdb): bad tree block start, want 30720000 have 0
[ 2865.267825] BTRFS error (device vdb): block=30720000 read time tree block corruption detected
[ 2865.276321] BTRFS error (device vdb): block=30670848 read time tree block corruption detected
[ 2865.380720] BTRFS error (device vdb): block=30687232 read time tree block corruption detected
[ 2865.477717] BTRFS error (device vdb): bad tree block start, want 30687232 have 0
[ 2865.487564] BTRFS error (device vdb): block=30687232 read time tree block corruption detected
[ 2865.628551] BTRFS error (device vdb): bad tree block start, want 30703616 have 0
[ 2865.636510] BTRFS error (device vdb): block=30703616 read time tree block corruption detected
[ 2865.842136] BTRFS error (device vdb): bad tree block start, want 30720000 have 0
[ 2865.845901] BTRFS error (device vdb): block=30720000 read time tree block corruption detected
[ 2866.072213] BTRFS error (device vdb): bad tree block start, want 30736384 have 0
[ 2866.081387] BTRFS error (device vdb): block=30736384 read time tree block corruption detected
[ 2866.253507] BTRFS error (device vdb): bad tree block start, want 30769152 have 0
[ 2866.253527] BTRFS error (device vdb): block=30801920 read time tree block corruption detected

[ 2866.253538] BTRFS error (device vdb): block=30752768 read time tree block corruption detected
[ 2866.253550] BTRFS error (device vdb): block=30818304 read time tree block corruption detected
[ 2866.263700] BTRFS error (device vdb): block=30769152 read time tree block corruption detected
[ 2866.273628] BTRFS error (device vdb): block=30785536 read time tree block corruption detected
[ 2866.474143] BTRFS error (device vdb): block=30769152 read time tree block corruption detected
[ 2866.576807] BTRFS error (device vdb): block=30785536 read time tree block corruption detected
[ 2866.793977] BTRFS error (device vdb): block=30801920 read time tree block corruption detected
[ 2866.997914] BTRFS error (device vdb): block=30818304 read time tree block corruption detected
[ 2867.157625] BTRFS error (device vdb): block=30834688 read time tree block corruption detected
[ 2867.157684] BTRFS error (device vdb): block=30851072 read time tree block corruption detected
[ 2867.162566] BTRFS error (device vdb): block=30867456 read time tree block corruption detected
[ 2867.162581] BTRFS error (device vdb): block=30883840 read time tree block corruption detected
[ 2867.162591] BTRFS error (device vdb): block=30900224 read time tree block corruption detected
[ 2867.393541] BTRFS error (device vdb): block=30851072 read time tree block corruption detected
[ 2867.556641] BTRFS error (device vdb): block=30867456 read time tree block corruption detected
[ 2867.787270] BTRFS error (device vdb): block=30883840 read time tree block corruption detected
[ 2867.997127] BTRFS error (device vdb): block=30900224 read time tree block corruption detected
[ 2868.205510] BTRFS error (device vdb): block=30916608 read time tree block corruption detected
[ 2868.205532] BTRFS error (device vdb): block=30949376 read time tree block corruption detected
[ 2868.205536] BTRFS error (device vdb): block=30932992 read time tree block corruption detected
[ 2868.205562] BTRFS error (device vdb): block=30965760 read time tree block corruption detected
[ 2868.205569] BTRFS error (device vdb): block=30982144 read time tree block corruption detected
[ 2868.388272] BTRFS error (device vdb): block=30932992 read time tree block corruption detected
[ 2868.592079] BTRFS error (device vdb): block=30949376 read time tree block corruption detected
[ 2868.794379] BTRFS error (device vdb): block=30965760 read time tree block corruption detected
[ 2868.999973] BTRFS error (device vdb): block=30982144 read time tree block corruption detected
[ 2869.207738] BTRFS error (device vdb): block=31014912 read time tree block corruption detected
[ 2869.207772] BTRFS error (device vdb): block=30998528 read time tree block corruption detected
[ 2869.207849] BTRFS error (device vdb): block=31031296 read time tree block corruption detected
[ 2869.207859] BTRFS error (device vdb): block=31047680 read time tree block corruption detected
[ 2869.207865] BTRFS error (device vdb): block=31064064 read time tree block corruption detected
[ 2869.430131] BTRFS error (device vdb): block=31014912 read time tree block corruption detected
[ 2869.583069] btrfs_print_data_csum_error: 178079 callbacks suppressed
[ 2869.583073] BTRFS warning (device vdb): csum failed root -9 ino 260 off 400269312 csum 0x5ce6193f expected csum 0x98f94189 mirror 1                                                                         
[ 2869.583088] BTRFS warning (device vdb): csum failed root -9 ino 260 off 399634432 csum 0x362910d4 expected csum 0x98f94189 mirror 1                                                                         
[ 2869.584130] BTRFS warning (device vdb): csum failed root -9 ino 260 off 400273408 csum 0xe3b70302 expected csum 0x98f94189 mirror 1                                                                         
[ 2869.586502] BTRFS warning (device vdb): csum failed root -9 ino 260 off 400277504 csum 0xe3b70302 expected csum 0x98f94189 mirror 1                                                                         
[ 2869.586609] BTRFS warning (device vdb): csum failed root -9 ino 260 off 400130048 csum 0x0bd5f454 expected csum 0x98f94189 mirror 1                                                                         
[ 2869.601709] BTRFS warning (device vdb): csum failed root -9 ino 260 off 400281600 csum 0xe3b70302 expected csum 0x98f94189 mirror 1                                                                         
[ 2869.601732] BTRFS warning (device vdb): csum failed root -9 ino 260 off 400134144 csum 0x0bd5f454 expected csum 0x98f94189 mirror 1                                                                         
[ 2869.606867] BTRFS warning (device vdb): csum failed root -9 ino 260 off 400138240 csum 0x0bd5f454 expected csum 0x98f94189 mirror 1                                                                         
[ 2869.606878] BTRFS warning (device vdb): csum failed root -9 ino 260 off 400285696 csum 0xe3b70302 expected csum 0x98f94189 mirror 1                                                                         
[ 2869.606912] BTRFS warning (device vdb): csum failed root -9 ino 260 off 400289792 csum 0xe3b70302 expected csum 0x98f94189 mirror 1                                                                         
[ 2869.678550] BTRFS error (device vdb): block=31031296 read time tree block corruption detected
[ 2869.782906] BTRFS error (device vdb): block=31047680 read time tree block corruption detected
[ 2870.010786] repair_io_failure: 89687 callbacks suppressed
[ 2870.010790] BTRFS info (device vdb): read error corrected: ino 260 off 430133248 (dev /dev/vdc sector 2955688)                                                                                              
[ 2870.010830] BTRFS info (device vdb): read error corrected: ino 260 off 430178304 (dev /dev/vdc sector 2955776)                                                                                              
[ 2870.010844] BTRFS info (device vdb): read error corrected: ino 260 off 430116864 (dev /dev/vdc sector 2955656)                                                                                              
[ 2870.011103] BTRFS info (device vdb): read error corrected: ino 260 off 430182400 (dev /dev/vdc sector 2955784)                                                                                              
[ 2870.011133] BTRFS info (device vdb): read error corrected: ino 260 off 430194688 (dev /dev/vdc sector 2955808)                                                                                              
[ 2870.011168] BTRFS info (device vdb): read error corrected: ino 260 off 430112768 (dev /dev/vdc sector 2955648)                                                                                              
[ 2870.011313] BTRFS info (device vdb): read error corrected: ino 260 off 430071808 (dev /dev/vdc sector 2955568)                                                                                              
[ 2870.011328] BTRFS info (device vdb): read error corrected: ino 260 off 430047232 (dev /dev/vdc sector 2955520)                                                                                              
[ 2870.011396] BTRFS info (device vdb): read error corrected: ino 260 off 430051328 (dev /dev/vdc sector 2955528)                                                                                              
[ 2870.011456] BTRFS info (device vdb): read error corrected: ino 260 off 429916160 (dev /dev/vdc sector 2955264)                                                                                              
[ 2870.017915] BTRFS error (device vdb): block=31064064 read time tree block corruption detected
[ 2870.254803] BTRFS error (device vdb): block=31096832 read time tree block corruption detected
[ 2870.254814] BTRFS error (device vdb): block=31080448 read time tree block corruption detected
[ 2870.254816] BTRFS error (device vdb): block=31113216 read time tree block corruption detected
[ 2870.254851] BTRFS error (device vdb): block=31129600 read time tree block corruption detected
[ 2870.254868] BTRFS error (device vdb): block=31145984 read time tree block corruption detected
[ 2870.468150] btree_readpage_end_io_hook: 40 callbacks suppressed

[ 2870.468154] BTRFS error (device vdb): bad tree block start, want 31096832 have 0
[ 2870.481275] BTRFS error (device vdb): block=31096832 read time tree block corruption detected
[ 2870.659389] BTRFS error (device vdb): bad tree block start, want 31113216 have 0
[ 2870.663667] BTRFS error (device vdb): block=31113216 read time tree block corruption detected
[ 2870.919169] BTRFS error (device vdb): bad tree block start, want 31129600 have 0
[ 2870.927705] BTRFS error (device vdb): block=31129600 read time tree block corruption detected
[ 2871.058301] BTRFS error (device vdb): bad tree block start, want 31145984 have 0
[ 2871.058336] BTRFS error (device vdb): bad tree block start, want 31162368 have 0
[ 2871.072181] BTRFS error (device vdb): bad tree block start, want 31178752 have 0
[ 2871.072185] BTRFS error (device vdb): bad tree block start, want 31211520 have 72340172838076673
[ 2871.072187] BTRFS error (device vdb): block=31211520 read time tree block corruption detected
[ 2871.072197] BTRFS error (device vdb): bad tree block start, want 31227904 have 72340172838076673
[ 2871.072198] BTRFS error (device vdb): block=31227904 read time tree block corruption detected
[ 2871.072264] BTRFS error (device vdb): bad tree block start, want 31195136 have 188978565376
[ 2871.072266] BTRFS error (device vdb): block=31195136 read time tree block corruption detected
[ 2871.076187] BTRFS error (device vdb): block=31162368 read time tree block corruption detected
[ 2871.081901] BTRFS error (device vdb): block=31178752 read time tree block corruption detected
[ 2871.091522] BTRFS error (device vdb): block=31145984 read time tree block corruption detected
[ 2871.686871] BTRFS error (device vdb): bad tree block start, want 31145984 have 0
[ 2871.701355] BTRFS error (device vdb): block=31145984 read time tree block corruption detected
[ 2871.883082] BTRFS error (device vdb): block=31162368 read time tree block corruption detected
[ 2872.070858] BTRFS error (device vdb): block=31227904 read time tree block corruption detected
[ 2872.209604] BTRFS error (device vdb): block=31195136 read time tree block corruption detected
[ 2872.524825] BTRFS error (device vdb): block=31211520 read time tree block corruption detected
[ 2872.773657] BTRFS error (device vdb): block=31260672 read time tree block corruption detected
[ 2872.773661] BTRFS error (device vdb): block=31277056 read time tree block corruption detected
[ 2872.773668] BTRFS error (device vdb): block=31244288 read time tree block corruption detected
[ 2872.773674] BTRFS error (device vdb): block=31293440 read time tree block corruption detected
[ 2872.773681] BTRFS error (device vdb): block=31309824 read time tree block corruption detected
[ 2872.930060] BTRFS error (device vdb): block=31260672 read time tree block corruption detected
[ 2873.179606] BTRFS error (device vdb): block=31277056 read time tree block corruption detected
[ 2873.346103] BTRFS error (device vdb): block=31293440 read time tree block corruption detected
[ 2873.517863] BTRFS error (device vdb): block=31309824 read time tree block corruption detected
[ 2873.705657] BTRFS error (device vdb): block=31326208 read time tree block corruption detected
[ 2873.705665] BTRFS error (device vdb): block=31358976 read time tree block corruption detected
[ 2873.705735] BTRFS error (device vdb): block=31375360 read time tree block corruption detected
[ 2873.705743] BTRFS error (device vdb): block=31391744 read time tree block corruption detected
[ 2873.706274] BTRFS error (device vdb): block=31342592 read time tree block corruption detected
[ 2874.081625] BTRFS error (device vdb): block=31342592 read time tree block corruption detected
[ 2874.408558] BTRFS error (device vdb): block=31358976 read time tree block corruption detected
[ 2874.587058] btrfs_print_data_csum_error: 132544 callbacks suppressed
[ 2874.587063] BTRFS warning (device vdb): csum failed root -9 ino 260 off 688840704 csum 0x434957d2 expected csum 0x98f94189 mirror 1                                                                         
[ 2874.587069] BTRFS warning (device vdb): csum failed root -9 ino 260 off 688975872 csum 0x0107a017 expected csum 0x98f94189 mirror 1                                                                         
[ 2874.587074] BTRFS warning (device vdb): csum failed root -9 ino 260 off 688984064 csum 0x7ef574ea expected csum 0x98f94189 mirror 1                                                                         
[ 2874.587090] BTRFS warning (device vdb): csum failed root -9 ino 260 off 688988160 csum 0xf077c653 expected csum 0x98f94189 mirror 1                                                                         
[ 2874.587096] BTRFS warning (device vdb): csum failed root -9 ino 260 off 688992256 csum 0xcd9f8290 expected csum 0x98f94189 mirror 1                                                                         
[ 2874.587109] BTRFS warning (device vdb): csum failed root -9 ino 260 off 689090560 csum 0x9d2a64a2 expected csum 0x98f94189 mirror 1                                                                         
[ 2874.587111] BTRFS warning (device vdb): csum failed root -9 ino 260 off 688996352 csum 0x60f06185 expected csum 0x98f94189 mirror 1                                                                         
[ 2874.587124] BTRFS warning (device vdb): csum failed root -9 ino 260 off 689094656 csum 0x6ad9235d expected csum 0x98f94189 mirror 1                                                                         
[ 2874.587129] BTRFS warning (device vdb): csum failed root -9 ino 260 off 689098752 csum 0xe2cb848d expected csum 0x98f94189 mirror 1                                                                         
[ 2874.597159] BTRFS error (device vdb): block=31375360 read time tree block corruption detected
[ 2874.881178] BTRFS error (device vdb): block=31391744 read time tree block corruption detected
[ 2874.892860] BTRFS error (device vdb): block=31408128 read time tree block corruption detected
[ 2874.892885] BTRFS error (device vdb): block=31457280 read time tree block corruption detected
[ 2874.892932] BTRFS error (device vdb): block=31440896 read time tree block corruption detected
[ 2874.893058] BTRFS error (device vdb): block=31473664 read time tree block corruption detected
[ 2874.893063] BTRFS error (device vdb): block=31490048 read time tree block corruption detected
[ 2874.952101] BTRFS error (device vdb): block=31424512 read time tree block corruption detected
[ 2875.011131] repair_io_failure: 65834 callbacks suppressed
[ 2875.011136] BTRFS info (device vdb): read error corrected: ino 260 off 711217152 (dev /dev/vdc sector 3504680)                                                                                              
[ 2875.011145] BTRFS info (device vdb): read error corrected: ino 260 off 710975488 (dev /dev/vdc sector 3504208)                                                                                              
[ 2875.011167] BTRFS info (device vdb): read error corrected: ino 260 off 711225344 (dev /dev/vdc sector 3504696)                                                                                              
[ 2875.011266] BTRFS info (device vdb): read error corrected: ino 260 off 711041024 (dev /dev/vdc sector 3504336)

[ 2875.011310] BTRFS info (device vdb): read error corrected: ino 260 off 711348224 (dev /dev/vdc sector 3504936)                                                                                              
[ 2875.014273] BTRFS info (device vdb): read error corrected: ino 260 off 710987776 (dev /dev/vdc sector 3504232)                                                                                              
[ 2875.014288] BTRFS info (device vdb): read error corrected: ino 260 off 710979584 (dev /dev/vdc sector 3504216)                                                                                              
[ 2875.014330] BTRFS info (device vdb): read error corrected: ino 260 off 710983680 (dev /dev/vdc sector 3504224)                                                                                              
[ 2875.014400] BTRFS info (device vdb): read error corrected: ino 260 off 710995968 (dev /dev/vdc sector 3504248)                                                                                              
[ 2875.014595] BTRFS info (device vdb): read error corrected: ino 260 off 711266304 (dev /dev/vdc sector 3504776)                                                                                              
[ 2875.147908] BTRFS error (device vdb): block=31408128 read time tree block corruption detected
[ 2875.380354] BTRFS error (device vdb): block=31424512 read time tree block corruption detected
[ 2875.565748] btree_readpage_end_io_hook: 30 callbacks suppressed
[ 2875.565753] BTRFS error (device vdb): bad tree block start, want 31457280 have 0
[ 2875.581223] BTRFS error (device vdb): block=31457280 read time tree block corruption detected
[ 2875.788290] BTRFS error (device vdb): bad tree block start, want 31473664 have 1085102592571150095
[ 2875.798989] BTRFS error (device vdb): block=31473664 read time tree block corruption detected
[ 2877.767277] BTRFS error (device vdb): bad tree block start, want 31490048 have 1085102592571150095
[ 2877.772654] BTRFS error (device vdb): block=31490048 read time tree block corruption detected
[ 2878.524728] BTRFS error (device vdb): bad tree block start, want 31506432 have 1085102592571150095
[ 2878.524766] BTRFS error (device vdb): bad tree block start, want 31522816 have 217020518514230019
[ 2878.524798] BTRFS error (device vdb): bad tree block start, want 31539200 have 217020518514230019
[ 2878.524800] BTRFS error (device vdb): block=31539200 read time tree block corruption detected
[ 2878.524835] BTRFS error (device vdb): bad tree block start, want 31571968 have 217020518514230019
[ 2878.524837] BTRFS error (device vdb): block=31571968 read time tree block corruption detected
[ 2878.524848] BTRFS error (device vdb): bad tree block start, want 31555584 have 217020518514230019
[ 2878.524849] BTRFS error (device vdb): block=31555584 read time tree block corruption detected
[ 2878.529852] BTRFS error (device vdb): block=31506432 read time tree block corruption detected
[ 2878.534202] BTRFS error (device vdb): block=31522816 read time tree block corruption detected
[ 2879.386342] BTRFS error (device vdb): bad tree block start, want 31522816 have 217020518514230019
[ 2879.400043] BTRFS error (device vdb): block=31522816 read time tree block corruption detected
[ 2879.638124] btrfs_print_data_csum_error: 59720 callbacks suppressed
[ 2879.638128] BTRFS warning (device vdb): csum failed root -9 ino 260 off 817057792 csum 0x576bf9a1 expected csum 0x98f94189 mirror 1                                                                         
[ 2879.638139] BTRFS warning (device vdb): csum failed root -9 ino 260 off 816893952 csum 0x7d29d791 expected csum 0x98f94189 mirror 1                                                                         
[ 2879.638760] BTRFS warning (device vdb): csum failed root -9 ino 260 off 816898048 csum 0x4c64848f expected csum 0x98f94189 mirror 1                                                                         
[ 2879.638814] BTRFS warning (device vdb): csum failed root -9 ino 260 off 816902144 csum 0x0107a017 expected csum 0x98f94189 mirror 1                                                                         
[ 2879.638856] BTRFS warning (device vdb): csum failed root -9 ino 260 off 817061888 csum 0x3dc46475 expected csum 0x98f94189 mirror 1                                                                         
[ 2879.638890] BTRFS warning (device vdb): csum failed root -9 ino 260 off 817065984 csum 0x63f98f58 expected csum 0x98f94189 mirror 1                                                                         
[ 2879.638915] BTRFS warning (device vdb): csum failed root -9 ino 260 off 817070080 csum 0x2a2250eb expected csum 0x98f94189 mirror 1                                                                         
[ 2879.638940] BTRFS warning (device vdb): csum failed root -9 ino 260 off 817074176 csum 0x90ece4b7 expected csum 0x98f94189 mirror 1                                                                         
[ 2879.640899] BTRFS warning (device vdb): csum failed root -9 ino 260 off 817000448 csum 0xe61df820 expected csum 0x98f94189 mirror 1                                                                         
[ 2879.640961] BTRFS warning (device vdb): csum failed root -9 ino 260 off 817078272 csum 0x222426ee expected csum 0x98f94189 mirror 1                                                                         
[ 2880.015085] repair_io_failure: 25064 callbacks suppressed
[ 2880.015089] BTRFS info (device vdb): read error corrected: ino 260 off 819994624 (dev /dev/vdc sector 3717136)                                                                                              
[ 2880.015186] BTRFS info (device vdb): read error corrected: ino 260 off 819200000 (dev /dev/vdc sector 3715584)                                                                                              
[ 2880.017126] BTRFS info (device vdb): read error corrected: ino 260 off 819195904 (dev /dev/vdc sector 3715576)                                                                                              
[ 2880.017197] BTRFS info (device vdb): read error corrected: ino 260 off 819204096 (dev /dev/vdc sector 3715592)                                                                                              
[ 2880.017226] BTRFS info (device vdb): read error corrected: ino 260 off 819212288 (dev /dev/vdc sector 3715608)                                                                                              
[ 2880.017359] BTRFS info (device vdb): read error corrected: ino 260 off 819216384 (dev /dev/vdc sector 3715616)                                                                                              
[ 2880.017392] BTRFS info (device vdb): read error corrected: ino 260 off 819220480 (dev /dev/vdc sector 3715624)                                                                                              
[ 2880.017430] BTRFS info (device vdb): read error corrected: ino 260 off 819224576 (dev /dev/vdc sector 3715632)                                                                                              
[ 2880.017598] BTRFS info (device vdb): read error corrected: ino 260 off 819228672 (dev /dev/vdc sector 3715640)                                                                                              
[ 2880.017706] BTRFS info (device vdb): read error corrected: ino 260 off 819232768 (dev /dev/vdc sector 3715648)                                                                                              
[ 2880.948226] BTRFS error (device vdb): bad tree block start, want 31539200 have 217020518514230019
[ 2880.952594] BTRFS error (device vdb): block=31539200 read time tree block corruption detected
[ 2881.118537] BTRFS error (device vdb): bad tree block start, want 31555584 have 217020518514230019
[ 2881.126228] BTRFS error (device vdb): block=31555584 read time tree block corruption detected
[ 2881.253287] BTRFS error (device vdb): bad tree block start, want 31571968 have 217020518514230019
[ 2881.259086] BTRFS error (device vdb): block=31571968 read time tree block corruption detected
[ 2881.474356] BTRFS error (device vdb): bad tree block start, want 31588352 have 0
[ 2881.474364] BTRFS error (device vdb): bad tree block start, want 31604736 have 0
[ 2881.474368] BTRFS error (device vdb): bad tree block start, want 31621120 have 0
[ 2881.474371] BTRFS error (device vdb): block=31621120 read time tree block corruption detected
[ 2881.474373] BTRFS error (device vdb): block=31588352 read time tree block corruption detected
[ 2881.478266] BTRFS error (device vdb): block=31604736 read time tree block corruption detected
[ 2881.742489] BTRFS error (device vdb): bad tree block start, want 31604736 have 0
[ 2881.746510] BTRFS error (device vdb): block=31604736 read time tree block corruption detected

[ 2882.057412] BTRFS error (device vdb): bad tree block start, want 31621120 have 0
[ 2882.073918] BTRFS error (device vdb): block=31621120 read time tree block corruption detected
[ 2888.507510] BTRFS info (device vdb): found 8 extents
[ 2890.081934] BTRFS info (device vdb): found 8 extents
[ 2890.201963] BTRFS info (device vdb): relocating block group 30408704 flags metadata|raid1
[ 2890.348951] BTRFS info (device vdb): found 82 extents
[ 2890.452777] BTRFS info (device vdb): relocating block group 22020096 flags system|raid1
[ 2890.564087] BTRFS info (device vdb): found 1 extents
[ 2890.648211] BTRFS info (device vdb): balance: ended with status: 0

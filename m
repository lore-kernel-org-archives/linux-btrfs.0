Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:38540 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752021AbeBUQmJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Feb 2018 11:42:09 -0500
Message-ID: <1519231321.3834.4.camel@scientia.net>
Subject: Re: BUG: unable to handle kernel paging request at ffff9fb75f827100
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Nikolay Borisov <nborisov@suse.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Wed, 21 Feb 2018 17:42:01 +0100
In-Reply-To: <478320b9-1972-2615-2e91-adc3d3f5112b@suse.com>
References: <1519186148.24817.1.camel@scientia.net>
         <478320b9-1972-2615-2e91-adc3d3f5112b@suse.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Spurious corruptions seem to continue....


[   69.688652] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   69.688656] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   69.688658] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   69.702870] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   69.702872] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   69.702875] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   69.865433] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   69.865436] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   69.865439] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   69.908030] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   69.908035] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   69.908040] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   69.949323] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   69.949326] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   69.949329] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   69.971228] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   69.971231] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   69.971235] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   69.998081] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   69.998084] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   69.998087] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.049415] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.049420] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.049424] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.067896] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.067900] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.067903] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.095769] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.095772] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.095775] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.106943] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.106946] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.106948] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.127554] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.127557] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.127561] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.133413] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.133415] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.133418] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.142557] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.142560] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.142564] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.166941] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.166944] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.166948] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.186688] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.186691] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.186693] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.204750] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.204753] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.204755] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.205652] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.205653] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.205655] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.211533] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.211535] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.211538] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.620630] BTRFS warning (device dm-0): csum failed root 257 ino
48217394 off 1490944 csum 0xd6431ab6 expected csum 0x85aae5a1 mirror 1
[   70.708791] BTRFS warning (device dm-0): csum failed root 257 ino
45366836 off 995328 csum 0x31675597 expected csum 0xa7b712fe mirror 1
[   70.911411] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.911415] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.911420] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.911824] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.911826] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.911829] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.917396] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.917399] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.917404] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.918849] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.918850] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.918853] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.920650] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.920652] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.920655] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.921365] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.921367] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.921369] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.922302] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.922305] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.922310] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.923958] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.923959] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.923962] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.924734] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.924735] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.924738] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.925967] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.925969] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.925973] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.926491] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.926493] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.926495] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.927483] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.927485] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.927487] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.927779] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.927780] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.927783] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.928185] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.928187] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   70.928191] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   70.929194] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.847988] btrfs_printk: 185 callbacks suppressed
[   76.847990] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.847994] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.847999] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   76.848416] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.848418] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.848421] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   76.853960] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.853963] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.853968] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   76.855390] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.855392] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.855395] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   76.857034] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.857036] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.857038] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   76.857706] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.857707] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.857709] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   76.858589] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.858590] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.858592] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   76.860282] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.860284] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.860286] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   76.860978] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.860979] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.860981] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   76.862142] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.862144] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.862146] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   76.862636] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.862637] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.862639] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   76.863704] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.863705] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.863708] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   76.863987] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.863988] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.863990] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   76.864341] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.864342] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.864344] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   76.865298] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.865300] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.865302] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   76.866119] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.866120] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.866122] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   76.867175] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.867177] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.867180] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   76.867250] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.867252] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.867254] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   76.867604] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.867606] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   76.867609] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   77.167259] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.167263] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.167268] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   77.167687] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.167689] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.167692] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   77.173395] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.173398] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.173413] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   77.174858] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.174860] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.174862] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   77.176679] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.176681] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.176684] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   77.177395] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.177396] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.177399] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   77.178346] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.178347] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.178350] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   77.180072] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.180074] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.180077] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   77.180815] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.180817] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.180820] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   77.182050] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.182052] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.182054] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   77.182588] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.182590] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.182592] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   77.183708] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.183710] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.183713] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   77.184008] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.184010] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.184012] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   77.184386] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.184387] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   77.184389] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   77.185397] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.072029] btrfs_printk: 242 callbacks suppressed
[   82.072030] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.072034] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.072041] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   82.072458] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.072459] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.072462] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   82.077862] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.077865] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.077869] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   82.079228] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.079230] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.079233] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   82.080847] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.080849] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.080851] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   82.081588] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.081590] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.081593] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   82.082562] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.082564] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.082566] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   82.084108] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.084109] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.084111] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   82.084817] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.084818] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.084820] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   82.086078] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.086080] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.086082] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   82.086575] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.086577] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.086579] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   82.087515] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.087516] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.087518] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   82.087798] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.087799] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.087801] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   82.088154] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.088155] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.088157] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   82.089103] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.089104] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.089106] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   82.090112] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.090115] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.090118] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   82.091132] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.091134] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.091136] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   82.091189] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.091190] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.091192] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   82.091458] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.091459] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   82.091461] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   86.364318] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.364323] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.364329] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   86.364970] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.364974] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.364980] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   86.372185] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.372189] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.372194] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   86.374062] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.374065] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.374068] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   86.376217] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.376220] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.376223] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   86.376976] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.376977] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.376979] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   86.378017] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.378020] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.378023] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   86.381432] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.381437] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.381443] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   86.382887] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.382891] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.382896] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   86.387217] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.387221] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.387228] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   86.388106] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.388108] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.388112] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   86.389400] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.389402] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.389405] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   86.389769] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.389772] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.389775] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   86.390260] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.390262] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   86.390264] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   86.391412] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.341657] btrfs_printk: 14 callbacks suppressed
[   90.341658] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.341662] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.341666] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   90.342041] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.342042] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.342044] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   90.347309] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.347312] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.347315] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   90.348692] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.348693] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.348696] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   90.350348] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.350350] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.350352] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   90.351025] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.351026] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.351028] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   90.351908] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.351909] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.351911] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   90.353507] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.353509] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.353512] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   90.354210] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.354212] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.354214] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   90.355370] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.355372] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.355374] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   90.355872] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.355873] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.355875] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   90.356813] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.356814] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.356817] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   90.357098] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.357100] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.357102] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   90.357478] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.357480] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.357482] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   90.358433] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.358434] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.358437] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   90.359259] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.359261] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.359263] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   90.360240] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.360242] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.360244] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   90.360310] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.360311] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.360314] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   90.360581] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.360582] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   90.360584] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   91.402556] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.402561] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.402565] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   91.402944] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.402945] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.402948] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   91.408239] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.408242] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.408246] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   91.409617] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.409619] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.409622] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   91.411340] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.411342] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.411345] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   91.412017] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.412019] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.412022] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   91.412907] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.412908] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.412911] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   91.414563] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.414564] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.414567] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   91.415271] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.415272] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.415274] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   91.416430] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.416432] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.416434] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   91.416930] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.416931] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.416933] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   91.417892] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.417894] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.417898] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   91.418262] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.418264] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.418267] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   91.418693] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.418695] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[   91.418697] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[   91.419654] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.708428] btrfs_printk: 14 callbacks suppressed
[  104.708430] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.708435] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.708440] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  104.708897] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.708899] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.708902] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  104.714450] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.714453] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.714457] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  104.715822] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.715823] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.715825] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  104.717524] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.717526] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.717528] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  104.718193] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.718195] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.718197] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  104.719081] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.719082] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.719084] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  104.720724] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.720725] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.720728] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  104.721425] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.721427] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.721429] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  104.722574] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.722575] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.722577] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  104.723064] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.723066] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.723068] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  104.723989] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.723990] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.723992] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  104.724316] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.724318] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.724321] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  104.724772] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.724773] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.724776] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  104.725792] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.725793] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.725796] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  104.726606] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.726607] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.726609] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  104.727571] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.727573] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.727575] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  104.727628] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.727629] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.727631] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  104.727893] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.727894] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  104.727896] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  106.081975] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.081980] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.081986] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  106.082405] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.082407] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.082410] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  106.088014] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.088019] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.088024] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  106.089480] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.089482] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.089485] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  106.091131] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.091133] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.091135] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  106.091812] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.091813] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.091815] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  106.092712] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.092713] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.092715] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  106.094417] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.094419] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.094422] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  106.095118] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.095119] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.095121] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  106.096296] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.096297] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.096299] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  106.096805] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.096807] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.096810] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  106.097864] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.097865] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.097867] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  106.098148] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.098149] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.098151] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  106.098501] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.098502] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  106.098504] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  106.099475] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.771546] btrfs_printk: 128 callbacks suppressed
[  109.771548] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.771552] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.771557] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  109.771933] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.771934] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.771936] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  109.777216] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.777219] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.777223] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  109.778606] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.778608] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.778613] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  109.780305] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.780307] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.780310] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  109.780972] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.780973] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.780975] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  109.781866] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.781867] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.781869] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  109.783515] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.783517] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.783519] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  109.784213] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.784214] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.784216] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  109.785380] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.785381] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.785383] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  109.785877] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.785879] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.785881] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  109.786899] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.786901] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.786904] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  109.787256] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.787257] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.787259] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  109.787619] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.787620] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.787622] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  109.788568] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.788570] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.788572] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  109.789387] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.789389] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.789390] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  109.790358] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.790359] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.790361] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  109.790414] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.790415] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.790417] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  109.790734] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.790736] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  109.790739] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  110.952370] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.952374] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.952379] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  110.952795] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.952797] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.952799] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  110.958003] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.958005] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.958009] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  110.959404] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.959406] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.959408] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  110.961033] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.961034] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.961036] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  110.961708] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.961710] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.961712] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  110.962600] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.962602] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.962604] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  110.964171] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.964173] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.964176] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  110.964874] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.964875] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.964877] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  110.966029] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.966031] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.966033] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  110.966523] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.966524] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.966527] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  110.967471] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.967473] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.967476] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  110.967754] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.967756] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.967758] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  110.968116] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.968118] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  110.968120] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  110.969067] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  115.348742] BTRFS warning (device dm-0): csum failed root 257 ino
48485975 off 1822720 csum 0x1378967c expected csum 0xe61c9719 mirror 1
[  115.455366] BTRFS warning (device dm-0): csum failed root 257 ino
48487099 off 3170304 csum 0xf23f1706 expected csum 0xe2c9913a mirror 1
[  115.484695] BTRFS warning (device dm-0): csum failed root 257 ino
48487113 off 1327104 csum 0xf4294d72 expected csum 0x09ff9446 mirror 1
[  115.498690] BTRFS warning (device dm-0): csum failed root 257 ino
48487113 off 4345856 csum 0xcbd0467a expected csum 0xff0df64d mirror 1
[  115.988579] BTRFS warning (device dm-0): csum failed root 257 ino
48654328 off 1777664 csum 0xf2e47ed3 expected csum 0x9f91c03a mirror 1
[  116.163699] BTRFS warning (device dm-0): csum failed root 257 ino
37794903 off 3993600 csum 0x891f4f87 expected csum 0x538376fd mirror 1
[  116.253885] btrfs_printk: 71 callbacks suppressed
[  116.253887] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.253891] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.253895] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  116.254419] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.254421] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.254424] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  116.260839] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.260842] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.260848] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  116.262400] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.262403] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.262407] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  116.264245] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.264249] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.264254] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  116.265005] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.265007] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.265010] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  116.266042] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.266045] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.266049] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  116.267819] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.267822] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.267827] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  116.268807] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.268811] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.268816] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  116.270697] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.270702] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.270707] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  116.271478] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.271481] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.271485] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  116.272698] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.272701] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.272705] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  116.273009] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.273011] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.273013] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  116.273396] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.273398] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.273400] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  116.274494] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.274496] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.274500] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  116.275398] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.275401] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.275404] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  116.276560] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.276564] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.276568] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  116.276628] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.276630] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.276632] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  116.276954] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.276955] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 4096
[  116.276958] BTRFS critical (device dm-0): unable to find logical
4503658729209856 length 16384
[  116.411864] dpkg-query[3813]: segfault at 8000000008 ip
0000557f4ab5b339 sp 00007fff84f44240 error 4 in dpkg-
query[557f4ab57000+22000]



I made a fsck from a USB stick:
checking extents
checking free space cache
Couldn't find free space inode 1
checking fs roots
checking csums
checking root refs
Checking filesystem on /dev/mapper/system
UUID: b6050e38-716a-40c3-a8df-fcf1dd7e655d
found 676124835840 bytes used, no error found
total csum bytes: 657522064
total tree bytes: 2546106368
total fs tree bytes: 1496350720
total extent tree bytes: 182255616
btree space waste bytes: 594036536
file data blocks allocated: 5032601706496
 referenced 670040977408


with lowmemmode:
checking extents
checking free space cache
Couldn't find free space inode 1
checking fs roots
checking csums
checking root refs
Checking filesystem on /dev/mapper/system
UUID: b6050e38-716a-40c3-a8df-fcf1dd7e655d
found 676124835840 bytes used, no error found
total csum bytes: 657522064
total tree bytes: 2546106368
total fs tree bytes: 1496350720
total extent tree bytes: 182255616
btree space waste bytes: 594036536
file data blocks allocated: 5032601706496
 referenced 670040977408


Tried twice clearing the v1 free space:
WARNING: free space inode 68719477715 not found, ignore
Clearing free space cache
Free space cache cleared

then...
Clearing free space cache
Free space cache cleared


But since then the fs seems basically broken

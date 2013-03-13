Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:41640 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab3CMIK1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Mar 2013 04:10:27 -0400
Received: from athlonxp.localnet (unknown [IPv6:2a01:e34:ef31:5f50:922b:34ff:fe35:5a3c])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 936BD940271
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2013 09:10:19 +0100 (CET)
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= COIFFIER <frederic.coiffier@free.fr>
To: linux-btrfs@vger.kernel.org
Subject: Re: How to recover uncorrectable errors ?
Date: Wed, 13 Mar 2013 09:10:16 +0100
Message-ID: <2849143.tI5ajWGIyz@athlonxp>
In-Reply-To: <6033676.gK0GbPgrpE@athlonxp>
References: <6033676.gK0GbPgrpE@athlonxp>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To complete my previous request, the log of btrfsck 0.20_rc1_p56 which segfaults :

checking extents
checksum verify failed on 272228352 wanted 119281BE found FFFFFFD3
checksum verify failed on 272228352 wanted 119281BE found FFFFFFD3
checksum verify failed on 272228352 wanted 119281BE found FFFFFFD3
checksum verify failed on 272228352 wanted 119281BE found FFFFFFD3
Csum didn't match
checksum verify failed on 556208128 wanted D88A417C found 11
checksum verify failed on 556208128 wanted D88A417C found 11
checksum verify failed on 556208128 wanted D88A417C found 11
checksum verify failed on 556208128 wanted D88A417C found 11
Csum didn't match
owner ref check failed [272228352 4096]
repair deleting extent record: key 272228352 168 4096
adding new tree backref on start 272228352 len 4096 parent 5 root 5
Backref 402792448 parent 2 root 2 not found in extent tree
Backref 402792448 root 2 not referenced back 0xa55ce08
Incorrect global backref count on 402792448 found 1 wanted 0
backpointer mismatch on [402792448 4096]
Backref 436817920 parent 2 root 2 not found in extent tree
Backref 436817920 root 2 not referenced back 0xa4b9488
Incorrect global backref count on 436817920 found 1 wanted 0
backpointer mismatch on [436817920 4096]
Backref 518414336 parent 2 root 2 not found in extent tree
Backref 518414336 root 2 not referenced back 0xa55b0c8
Incorrect global backref count on 518414336 found 1 wanted 0
backpointer mismatch on [518414336 4096]
Backref 540577792 parent 2 root 2 not found in extent tree
Backref 540577792 root 2 not referenced back 0x8793588
Incorrect global backref count on 540577792 found 1 wanted 0
backpointer mismatch on [540577792 4096]
owner ref check failed [556208128 4096]
repair deleting extent record: key 556208128 168 4096
adding new tree backref on start 556208128 len 4096 parent 5 root 5
Backref 565420032 parent 2 root 2 not found in extent tree
Backref 565420032 root 2 not referenced back 0xa437620
Incorrect global backref count on 565420032 found 1 wanted 0
backpointer mismatch on [565420032 4096]
Backref 597049344 parent 2 root 2 not found in extent tree
Backref 597049344 root 2 not referenced back 0xa414720
Incorrect global backref count on 597049344 found 1 wanted 0
backpointer mismatch on [597049344 4096]
Backref 610033664 parent 2 root 2 not found in extent tree
Backref 610033664 root 2 not referenced back 0xa46f250
Incorrect global backref count on 610033664 found 1 wanted 0
backpointer mismatch on [610033664 4096]
Backref 636481536 parent 2 root 2 not found in extent tree
Backref 636481536 root 2 not referenced back 0xa4d53c8
Incorrect global backref count on 636481536 found 1 wanted 0
backpointer mismatch on [636481536 4096]
Backref 673796096 parent 2 root 2 not found in extent tree
Backref 673796096 root 2 not referenced back 0xa474368
Incorrect global backref count on 673796096 found 1 wanted 0
backpointer mismatch on [673796096 4096]
Backref 717684736 parent 2 root 2 not found in extent tree
Backref 717684736 root 2 not referenced back 0x8793658
Incorrect global backref count on 717684736 found 1 wanted 0
backpointer mismatch on [717684736 4096]
Backref 739885056 parent 2 root 2 not found in extent tree
Backref 739885056 root 2 not referenced back 0xa501d20
Incorrect global backref count on 739885056 found 1 wanted 0
backpointer mismatch on [739885056 4096]
Backref 745107456 parent 2 root 2 not found in extent tree
Backref 745107456 root 2 not referenced back 0xa562260
Incorrect global backref count on 745107456 found 1 wanted 0
backpointer mismatch on [745107456 4096]
Backref 770273280 parent 2 root 2 not found in extent tree
Backref 770273280 root 2 not referenced back 0xa482138
Incorrect global backref count on 770273280 found 1 wanted 0
backpointer mismatch on [770273280 4096]
Backref 771325952 parent 2 root 2 not found in extent tree
Backref 771325952 root 2 not referenced back 0x8638260
Incorrect global backref count on 771325952 found 1 wanted 0
backpointer mismatch on [771325952 4096]
Backref 775409664 parent 2 root 2 not found in extent tree
Backref 775409664 root 2 not referenced back 0x81a3068
Incorrect global backref count on 775409664 found 1 wanted 0
backpointer mismatch on [775409664 4096]
Backref 775598080 parent 2 root 2 not found in extent tree
Backref 775598080 root 2 not referenced back 0x81a7540
Incorrect global backref count on 775598080 found 1 wanted 0
backpointer mismatch on [775598080 4096]
Backref 775700480 parent 2 root 2 not found in extent tree
Backref 775700480 root 2 not referenced back 0x8639100
Incorrect global backref count on 775700480 found 1 wanted 0
backpointer mismatch on [775700480 4096]
Backref 775729152 parent 2 root 2 not found in extent tree
Backref 775729152 root 2 not referenced back 0xa428248
Incorrect global backref count on 775729152 found 1 wanted 0
backpointer mismatch on [775729152 4096]
Backref 775761920 parent 2 root 2 not found in extent tree
Backref 775761920 root 2 not referenced back 0xa428318
Incorrect global backref count on 775761920 found 1 wanted 0
backpointer mismatch on [775761920 4096]
Backref 775892992 parent 2 root 2 not found in extent tree
Backref 775892992 root 2 not referenced back 0xa4283e8
Incorrect global backref count on 775892992 found 1 wanted 0
backpointer mismatch on [775892992 4096]
Backref 775909376 parent 2 root 2 not found in extent tree
Backref 775909376 root 2 not referenced back 0xa4284b8
Incorrect global backref count on 775909376 found 1 wanted 0
backpointer mismatch on [775909376 4096]
Backref 775950336 parent 2 root 2 not found in extent tree
Backref 775950336 root 2 not referenced back 0x86391d0
Incorrect global backref count on 775950336 found 1 wanted 0
backpointer mismatch on [775950336 4096]
Backref 776458240 parent 2 root 2 not found in extent tree
Backref 776458240 root 2 not referenced back 0xa428a68
Incorrect global backref count on 776458240 found 1 wanted 0
backpointer mismatch on [776458240 4096]
Backref 776753152 parent 2 root 2 not found in extent tree
Backref 776753152 root 2 not referenced back 0xa428728
Incorrect global backref count on 776753152 found 1 wanted 0
backpointer mismatch on [776753152 4096]
Backref 776765440 parent 2 root 2 not found in extent tree
Backref 776765440 root 2 not referenced back 0xa4288c8
Incorrect global backref count on 776765440 found 1 wanted 0
backpointer mismatch on [776765440 4096]
Backref 776851456 parent 2 root 2 not found in extent tree
Backref 776851456 root 2 not referenced back 0x8637b10
Incorrect global backref count on 776851456 found 1 wanted 0
backpointer mismatch on [776851456 4096]
Backref 777175040 parent 2 root 2 not found in extent tree
Backref 777175040 root 2 not referenced back 0x86392a0
Incorrect global backref count on 777175040 found 1 wanted 0
backpointer mismatch on [777175040 4096]
Backref 777465856 parent 2 root 2 not found in extent tree
Backref 777465856 root 2 not referenced back 0xa44bee8
Incorrect global backref count on 777465856 found 1 wanted 0
backpointer mismatch on [777465856 4096]
Backref 777633792 parent 2 root 2 not found in extent tree
Backref 777633792 root 2 not referenced back 0x8638330
Incorrect global backref count on 777633792 found 1 wanted 0
backpointer mismatch on [777633792 4096]
Backref 778764288 parent 2 root 2 not found in extent tree
Backref 778764288 root 2 not referenced back 0x8637ff0
Incorrect global backref count on 778764288 found 1 wanted 0
backpointer mismatch on [778764288 4096]
Backref 778891264 parent 2 root 2 not found in extent tree
Backref 778891264 root 2 not referenced back 0x8638740
Incorrect global backref count on 778891264 found 1 wanted 0
backpointer mismatch on [778891264 4096]
Backref 779280384 parent 2 root 2 not found in extent tree
Backref 779280384 root 2 not referenced back 0x8638e90
Incorrect global backref count on 779280384 found 1 wanted 0
backpointer mismatch on [779280384 4096]
Backref 779673600 parent 2 root 2 not found in extent tree
Backref 779673600 root 2 not referenced back 0xa428cd8
Incorrect global backref count on 779673600 found 1 wanted 0
backpointer mismatch on [779673600 4096]
Backref 781275136 parent 2 root 2 not found in extent tree
Backref 781275136 root 2 not referenced back 0xa429768
Incorrect global backref count on 781275136 found 1 wanted 0
backpointer mismatch on [781275136 4096]
Backref 781406208 parent 2 root 2 not found in extent tree
Backref 781406208 root 2 not referenced back 0xa517e80
Incorrect global backref count on 781406208 found 1 wanted 0
backpointer mismatch on [781406208 4096]
Backref 782848000 parent 2 root 2 not found in extent tree
Backref 782848000 root 2 not referenced back 0xa42c098
Incorrect global backref count on 782848000 found 1 wanted 0
backpointer mismatch on [782848000 4096]
Backref 783228928 parent 2 root 2 not found in extent tree
Backref 783228928 root 2 not referenced back 0xa429e78
Incorrect global backref count on 783228928 found 1 wanted 0
backpointer mismatch on [783228928 4096]
Backref 783355904 parent 2 root 2 not found in extent tree
Backref 783355904 root 2 not referenced back 0xa42a4f8
Incorrect global backref count on 783355904 found 1 wanted 0
backpointer mismatch on [783355904 4096]
Backref 783376384 parent 2 root 2 not found in extent tree
Backref 783376384 root 2 not referenced back 0xa42a698
Incorrect global backref count on 783376384 found 1 wanted 0
backpointer mismatch on [783376384 4096]
Backref 783405056 parent 2 root 2 not found in extent tree
Backref 783405056 root 2 not referenced back 0xa42a768
Incorrect global backref count on 783405056 found 1 wanted 0
backpointer mismatch on [783405056 4096]
Backref 784048128 parent 2 root 2 not found in extent tree
Backref 784048128 root 2 not referenced back 0xa429288
Incorrect global backref count on 784048128 found 1 wanted 0
backpointer mismatch on [784048128 4096]
Backref 784093184 parent 2 root 2 not found in extent tree
Backref 784093184 root 2 not referenced back 0xa429358
Incorrect global backref count on 784093184 found 1 wanted 0
backpointer mismatch on [784093184 4096]
Backref 784101376 parent 2 root 2 not found in extent tree
Backref 784101376 root 2 not referenced back 0xa4294f8
Incorrect global backref count on 784101376 found 1 wanted 0
backpointer mismatch on [784101376 4096]
Backref 784330752 parent 2 root 2 not found in extent tree
Backref 784330752 root 2 not referenced back 0xa426ab8
Incorrect global backref count on 784330752 found 1 wanted 0
backpointer mismatch on [784330752 4096]
Backref 784388096 parent 2 root 2 not found in extent tree
Backref 784388096 root 2 not referenced back 0xa42ab78
Incorrect global backref count on 784388096 found 1 wanted 0
backpointer mismatch on [784388096 4096]
Backref 784637952 parent 2 root 2 not found in extent tree
Backref 784637952 root 2 not referenced back 0xa42ac48
Incorrect global backref count on 784637952 found 1 wanted 0
backpointer mismatch on [784637952 4096]
Backref 784650240 parent 2 root 2 not found in extent tree
Backref 784650240 root 2 not referenced back 0xa42ade8
Incorrect global backref count on 784650240 found 1 wanted 0
backpointer mismatch on [784650240 4096]
Backref 784830464 parent 2 root 2 not found in extent tree
Backref 784830464 root 2 not referenced back 0x8637150
Incorrect global backref count on 784830464 found 1 wanted 0
backpointer mismatch on [784830464 4096]
Backref 785096704 parent 2 root 2 not found in extent tree
Backref 785096704 root 2 not referenced back 0xa42aeb8
Incorrect global backref count on 785096704 found 1 wanted 0
backpointer mismatch on [785096704 4096]
Backref 785129472 parent 2 root 2 not found in extent tree
Backref 785129472 root 2 not referenced back 0xa42aaa8
Incorrect global backref count on 785129472 found 1 wanted 0
backpointer mismatch on [785129472 4096]
Backref 785215488 parent 2 root 2 not found in extent tree
Backref 785215488 root 2 not referenced back 0xa42b058
Incorrect global backref count on 785215488 found 1 wanted 0
backpointer mismatch on [785215488 4096]
Backref 786165760 parent 2 root 2 not found in extent tree
Backref 786165760 root 2 not referenced back 0x81aada8
Incorrect global backref count on 786165760 found 1 wanted 0
backpointer mismatch on [786165760 4096]
Backref 786239488 parent 2 root 2 not found in extent tree
Backref 786239488 root 2 not referenced back 0xa44b528
Incorrect global backref count on 786239488 found 1 wanted 0
backpointer mismatch on [786239488 4096]
Backref 786452480 parent 2 root 2 not found in extent tree
Backref 786452480 root 2 not referenced back 0xa44be18
Incorrect global backref count on 786452480 found 1 wanted 0
backpointer mismatch on [786452480 4096]
Backref 786620416 parent 2 root 2 not found in extent tree
Backref 786620416 root 2 not referenced back 0xa42b468
Incorrect global backref count on 786620416 found 1 wanted 0
backpointer mismatch on [786620416 4096]
Backref 786780160 parent 2 root 2 not found in extent tree
Backref 786780160 root 2 not referenced back 0xa42b608
Incorrect global backref count on 786780160 found 1 wanted 0
backpointer mismatch on [786780160 4096]
Backref 786808832 parent 2 root 2 not found in extent tree
Backref 786808832 root 2 not referenced back 0xa503d68
Incorrect global backref count on 786808832 found 1 wanted 0
backpointer mismatch on [786808832 4096]
Backref 786870272 parent 2 root 2 not found in extent tree
Backref 786870272 root 2 not referenced back 0xa42b6d8
Incorrect global backref count on 786870272 found 1 wanted 0
backpointer mismatch on [786870272 4096]
Backref 786874368 parent 2 root 2 not found in extent tree
Backref 786874368 root 2 not referenced back 0xa42b7a8
Incorrect global backref count on 786874368 found 1 wanted 0
backpointer mismatch on [786874368 4096]
Backref 787447808 parent 2 root 2 not found in extent tree
Backref 787447808 root 2 not referenced back 0xa45a820
Incorrect global backref count on 787447808 found 1 wanted 0
backpointer mismatch on [787447808 4096]
Backref 787599360 parent 2 root 2 not found in extent tree
Backref 787599360 root 2 not referenced back 0xa42ca58
Incorrect global backref count on 787599360 found 1 wanted 0
backpointer mismatch on [787599360 4096]
Backref 787660800 parent 2 root 2 not found in extent tree
Backref 787660800 root 2 not referenced back 0xa42ba18
Incorrect global backref count on 787660800 found 1 wanted 0
backpointer mismatch on [787660800 4096]
Backref 787668992 parent 2 root 2 not found in extent tree
Backref 787668992 root 2 not referenced back 0xa42bae8
Incorrect global backref count on 787668992 found 1 wanted 0
backpointer mismatch on [787668992 4096]
Backref 787922944 parent 2 root 2 not found in extent tree
Backref 787922944 root 2 not referenced back 0x8638190
Incorrect global backref count on 787922944 found 1 wanted 0
backpointer mismatch on [787922944 4096]
Backref 788348928 parent 2 root 2 not found in extent tree
Backref 788348928 root 2 not referenced back 0x86385a0
Incorrect global backref count on 788348928 found 1 wanted 0
backpointer mismatch on [788348928 4096]
Backref 788504576 parent 2 root 2 not found in extent tree
Backref 788504576 root 2 not referenced back 0xa4e3460
Incorrect global backref count on 788504576 found 1 wanted 0
backpointer mismatch on [788504576 4096]
Backref 788635648 parent 2 root 2 not found in extent tree
Backref 788635648 root 2 not referenced back 0xa42bc88
Incorrect global backref count on 788635648 found 1 wanted 0
backpointer mismatch on [788635648 4096]
Backref 788688896 parent 2 root 2 not found in extent tree
Backref 788688896 root 2 not referenced back 0xa42be28
Incorrect global backref count on 788688896 found 1 wanted 0
backpointer mismatch on [788688896 4096]
Backref 788709376 parent 2 root 2 not found in extent tree
Backref 788709376 root 2 not referenced back 0xa42bef8
Incorrect global backref count on 788709376 found 1 wanted 0
backpointer mismatch on [788709376 4096]
Backref 788717568 parent 2 root 2 not found in extent tree
Backref 788717568 root 2 not referenced back 0xa42bfc8
Incorrect global backref count on 788717568 found 1 wanted 0
backpointer mismatch on [788717568 4096]
Backref 790511616 parent 2 root 2 not found in extent tree
Backref 790511616 root 2 not referenced back 0xa44bd48
Incorrect global backref count on 790511616 found 1 wanted 0
backpointer mismatch on [790511616 4096]
Backref 790540288 parent 2 root 2 not found in extent tree
Backref 790540288 root 2 not referenced back 0xa42c988
Incorrect global backref count on 790540288 found 1 wanted 0
backpointer mismatch on [790540288 4096]
Backref 790740992 parent 2 root 2 not found in extent tree
Backref 790740992 root 2 not referenced back 0x86389b0
Incorrect global backref count on 790740992 found 1 wanted 0
backpointer mismatch on [790740992 4096]
Backref 790753280 parent 2 root 2 not found in extent tree
Backref 790753280 root 2 not referenced back 0x8638cf0
Incorrect global backref count on 790753280 found 1 wanted 0
backpointer mismatch on [790753280 4096]
Backref 792076288 parent 2 root 2 not found in extent tree
Backref 792076288 root 2 not referenced back 0x86384d0
Incorrect global backref count on 792076288 found 1 wanted 0
backpointer mismatch on [792076288 4096]
Backref 793780224 parent 2 root 2 not found in extent tree
Backref 793780224 root 2 not referenced back 0x81baea8
Incorrect global backref count on 793780224 found 1 wanted 0
backpointer mismatch on [793780224 4096]
Backref 793821184 parent 2 root 2 not found in extent tree
Backref 793821184 root 2 not referenced back 0x8637080
Incorrect global backref count on 793821184 found 1 wanted 0
backpointer mismatch on [793821184 4096]
Backref 793853952 parent 2 root 2 not found in extent tree
Backref 793853952 root 2 not referenced back 0x86378a0
Incorrect global backref count on 793853952 found 1 wanted 0
backpointer mismatch on [793853952 4096]
ref mismatch on [31078330368 20480] extent item 1, found 0
repair deleting extent record: key 31078330368 168 20480
Incorrect local backref count on 31078330368 root 5 owner 3024239 offset 0 found 0 wanted 1 back 0x8f00580
backpointer mismatch on [31078330368 20480]
owner ref check failed [31078330368 20480]
repaired damaged extent references
checking fs roots
checksum verify failed on 272228352 wanted 119281BE found FFFFFFD3
checksum verify failed on 272228352 wanted 119281BE found FFFFFFD3
checksum verify failed on 272228352 wanted 119281BE found FFFFFFD3
checksum verify failed on 272228352 wanted 119281BE found FFFFFFD3
Csum didn't match

Regards,
Frederic

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:33472 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab3AONuF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jan 2013 08:50:05 -0500
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-9.4) with ESMTP id r0FDdXtS012324
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2013 14:39:33 +0100
Received: from mail2.itwm.fhg.de ([131.246.191.79]:60304)
	by itwm2.itwm.fhg.de with esmtps (TLSv1:DES-CBC3-SHA:168)
	(/C=DE/ST=Rheinland-Pfalz/L=Kaiserslautern/O=Fraunhofer ITWM/OU=SLG/CN=mail2.itwm.fhg.de)(verified=1)
	 (Exim 4.74 #1)
	id 1Tv6jl-0006nr-9i
	for linux-btrfs@vger.kernel.org; Tue, 15 Jan 2013 14:39:33 +0100
Message-ID: <50F55C14.4090605@itwm.fraunhofer.de>
Date: Tue, 15 Jan 2013 14:39:32 +0100
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
MIME-Version: 1.0
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: abort transaction and RO
References: <kd3l1c$bd$1@ger.gmane.org> <50F55B1F.7050608@itwm.fraunhofer.de>
In-Reply-To: <50F55B1F.7050608@itwm.fraunhofer.de>
Content-Type: multipart/mixed;
 boundary="------------030302020901050409090004"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030302020901050409090004
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/15/2013 02:35 PM, Bernd Schubert wrote:
> Hrmm, that bug then seems to cause another bug. After the file system
> went into RO, I simply umounted and mounted again and a few seconds
> after that my entire system failed. Relevant logs are attached.
>

Further log attachment:

btrfsck /dev/vg_fuj2/test  >/tmp/btrfs.log 2>&1



--------------030302020901050409090004
Content-Type: text/x-log;
 name="btrfs.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="btrfs.log"

checking extents
ref mismatch on [12689408 262144] extent item 1, found 0
Incorrect local backref count on 12689408 root 1 owner 256 offset 0 found 0 wanted 1 back 0x1869ef0
backpointer mismatch on [12689408 262144]
owner ref check failed [12689408 262144]
ref mismatch on [12951552 262144] extent item 0, found 1
Backref 12951552 root 1 owner 256 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 12951552 root 1 owner 256 offset 0 found 1 wanted 0 back 0x185faa0
backpointer mismatch on [12951552 262144]
ref mismatch on [13213696 262144] extent item 1, found 0
Incorrect local backref count on 13213696 root 1 owner 273 offset 0 found 0 wanted 1 back 0x1869fd0
backpointer mismatch on [13213696 262144]
owner ref check failed [13213696 262144]
ref mismatch on [13475840 262144] extent item 1, found 0
Incorrect local backref count on 13475840 root 1 owner 259 offset 0 found 0 wanted 1 back 0x186a0b0
backpointer mismatch on [13475840 262144]
owner ref check failed [13475840 262144]
ref mismatch on [13737984 262144] extent item 1, found 0
Incorrect local backref count on 13737984 root 1 owner 260 offset 0 found 0 wanted 1 back 0x186a190
backpointer mismatch on [13737984 262144]
owner ref check failed [13737984 262144]
ref mismatch on [14000128 262144] extent item 1, found 0
Incorrect local backref count on 14000128 root 1 owner 261 offset 0 found 0 wanted 1 back 0x186a270
backpointer mismatch on [14000128 262144]
owner ref check failed [14000128 262144]
ref mismatch on [14262272 262144] extent item 1, found 0
Incorrect local backref count on 14262272 root 1 owner 257 offset 0 found 0 wanted 1 back 0x186a350
backpointer mismatch on [14262272 262144]
owner ref check failed [14262272 262144]
ref mismatch on [14524416 262144] extent item 1, found 0
Incorrect local backref count on 14524416 root 1 owner 262 offset 0 found 0 wanted 1 back 0x186a430
backpointer mismatch on [14524416 262144]
owner ref check failed [14524416 262144]
ref mismatch on [14786560 262144] extent item 1, found 0
Incorrect local backref count on 14786560 root 1 owner 263 offset 0 found 0 wanted 1 back 0x186a510
backpointer mismatch on [14786560 262144]
owner ref check failed [14786560 262144]
ref mismatch on [15048704 262144] extent item 1, found 0
Incorrect local backref count on 15048704 root 1 owner 264 offset 0 found 0 wanted 1 back 0x186a5f0
backpointer mismatch on [15048704 262144]
owner ref check failed [15048704 262144]
ref mismatch on [15310848 262144] extent item 1, found 0
Incorrect local backref count on 15310848 root 1 owner 265 offset 0 found 0 wanted 1 back 0x186a6d0
backpointer mismatch on [15310848 262144]
owner ref check failed [15310848 262144]
ref mismatch on [15572992 262144] extent item 1, found 0
Incorrect local backref count on 15572992 root 1 owner 266 offset 0 found 0 wanted 1 back 0x186a7b0
backpointer mismatch on [15572992 262144]
owner ref check failed [15572992 262144]
ref mismatch on [15835136 262144] extent item 1, found 0
Incorrect local backref count on 15835136 root 1 owner 267 offset 0 found 0 wanted 1 back 0x186a890
backpointer mismatch on [15835136 262144]
owner ref check failed [15835136 262144]
ref mismatch on [16097280 262144] extent item 1, found 0
Incorrect local backref count on 16097280 root 1 owner 268 offset 0 found 0 wanted 1 back 0x186a970
backpointer mismatch on [16097280 262144]
owner ref check failed [16097280 262144]
ref mismatch on [16359424 262144] extent item 1, found 0
Incorrect local backref count on 16359424 root 1 owner 269 offset 0 found 0 wanted 1 back 0x186aa50
backpointer mismatch on [16359424 262144]
owner ref check failed [16359424 262144]
ref mismatch on [16621568 262144] extent item 1, found 0
Incorrect local backref count on 16621568 root 1 owner 270 offset 0 found 0 wanted 1 back 0x186ab30
backpointer mismatch on [16621568 262144]
owner ref check failed [16621568 262144]
ref mismatch on [16883712 262144] extent item 1, found 0
Incorrect local backref count on 16883712 root 1 owner 271 offset 0 found 0 wanted 1 back 0x186ac10
backpointer mismatch on [16883712 262144]
owner ref check failed [16883712 262144]
ref mismatch on [17145856 262144] extent item 1, found 0
Incorrect local backref count on 17145856 root 1 owner 272 offset 0 found 0 wanted 1 back 0x186acf0
backpointer mismatch on [17145856 262144]
owner ref check failed [17145856 262144]
ref mismatch on [17408000 262144] extent item 1, found 0
Incorrect local backref count on 17408000 root 1 owner 281 offset 0 found 0 wanted 1 back 0x186add0
backpointer mismatch on [17408000 262144]
owner ref check failed [17408000 262144]
ref mismatch on [17670144 262144] extent item 1, found 0
Incorrect local backref count on 17670144 root 1 owner 274 offset 0 found 0 wanted 1 back 0x186aeb0
backpointer mismatch on [17670144 262144]
owner ref check failed [17670144 262144]
ref mismatch on [17932288 262144] extent item 1, found 0
Incorrect local backref count on 17932288 root 1 owner 275 offset 0 found 0 wanted 1 back 0x186af90
backpointer mismatch on [17932288 262144]
owner ref check failed [17932288 262144]
ref mismatch on [18194432 262144] extent item 1, found 0
Incorrect local backref count on 18194432 root 1 owner 276 offset 0 found 0 wanted 1 back 0x185fa50
backpointer mismatch on [18194432 262144]
owner ref check failed [18194432 262144]
ref mismatch on [18456576 262144] extent item 1, found 0
Incorrect local backref count on 18456576 root 1 owner 277 offset 0 found 0 wanted 1 back 0x186b110
backpointer mismatch on [18456576 262144]
owner ref check failed [18456576 262144]
ref mismatch on [18718720 262144] extent item 1, found 0
Incorrect local backref count on 18718720 root 1 owner 278 offset 0 found 0 wanted 1 back 0x186b1f0
backpointer mismatch on [18718720 262144]
owner ref check failed [18718720 262144]
ref mismatch on [18980864 262144] extent item 1, found 0
Incorrect local backref count on 18980864 root 1 owner 279 offset 0 found 0 wanted 1 back 0x186b2d0
backpointer mismatch on [18980864 262144]
owner ref check failed [18980864 262144]
ref mismatch on [19243008 262144] extent item 1, found 0
Incorrect local backref count on 19243008 root 1 owner 280 offset 0 found 0 wanted 1 back 0x186b3b0
backpointer mismatch on [19243008 262144]
owner ref check failed [19243008 262144]
ref mismatch on [19505152 262144] extent item 1, found 0
Incorrect local backref count on 19505152 root 1 owner 289 offset 0 found 0 wanted 1 back 0x186b490
backpointer mismatch on [19505152 262144]
owner ref check failed [19505152 262144]
ref mismatch on [19767296 262144] extent item 1, found 0
Incorrect local backref count on 19767296 root 1 owner 282 offset 0 found 0 wanted 1 back 0x186b570
backpointer mismatch on [19767296 262144]
owner ref check failed [19767296 262144]
ref mismatch on [20029440 262144] extent item 1, found 0
Incorrect local backref count on 20029440 root 1 owner 283 offset 0 found 0 wanted 1 back 0x186b650
backpointer mismatch on [20029440 262144]
owner ref check failed [20029440 262144]
ref mismatch on [20291584 262144] extent item 1, found 0
Incorrect local backref count on 20291584 root 1 owner 284 offset 0 found 0 wanted 1 back 0x186b730
backpointer mismatch on [20291584 262144]
owner ref check failed [20291584 262144]
ref mismatch on [20553728 262144] extent item 1, found 0
Incorrect local backref count on 20553728 root 1 owner 285 offset 0 found 0 wanted 1 back 0x186b810
backpointer mismatch on [20553728 262144]
owner ref check failed [20553728 262144]
ref mismatch on [61448192 4096] extent item 0, found 1
Backref 61448192 parent 1 root 1 not found in extent tree
backpointer mismatch on [61448192 4096]
ref mismatch on [61452288 4096] extent item 0, found 1
Backref 61452288 parent 1 root 1 not found in extent tree
backpointer mismatch on [61452288 4096]
ref mismatch on [61456384 4096] extent item 0, found 1
Backref 61456384 parent 1 root 1 not found in extent tree
backpointer mismatch on [61456384 4096]
ref mismatch on [61460480 4096] extent item 0, found 1
Backref 61460480 parent 1 root 1 not found in extent tree
backpointer mismatch on [61460480 4096]
ref mismatch on [61464576 4096] extent item 0, found 1
Backref 61464576 parent 1 root 1 not found in extent tree
backpointer mismatch on [61464576 4096]
ref mismatch on [61468672 4096] extent item 0, found 1
Backref 61468672 parent 1 root 1 not found in extent tree
backpointer mismatch on [61468672 4096]
ref mismatch on [61472768 4096] extent item 0, found 1
Backref 61472768 parent 1 root 1 not found in extent tree
backpointer mismatch on [61472768 4096]
ref mismatch on [61476864 4096] extent item 0, found 1
Backref 61476864 parent 1 root 1 not found in extent tree
backpointer mismatch on [61476864 4096]
ref mismatch on [1069400064 4096] extent item 1, found 0
Backref 1069400064 root 1 not referenced back 0x18328c0
Incorrect global backref count on 1069400064 found 1 wanted 0
backpointer mismatch on [1069400064 4096]
owner ref check failed [1069400064 4096]
ref mismatch on [1075666944 4096] extent item 1, found 0
Backref 1075666944 root 1 not referenced back 0x1833500
Incorrect global backref count on 1075666944 found 1 wanted 0
backpointer mismatch on [1075666944 4096]
owner ref check failed [1075666944 4096]
ref mismatch on [1086574592 4096] extent item 1, found 0
Backref 1086574592 root 1 not referenced back 0x1832230
Incorrect global backref count on 1086574592 found 1 wanted 0
backpointer mismatch on [1086574592 4096]
owner ref check failed [1086574592 4096]
ref mismatch on [1089167360 4096] extent item 1, found 0
Backref 1089167360 root 1 not referenced back 0x1864de0
Incorrect global backref count on 1089167360 found 1 wanted 0
backpointer mismatch on [1089167360 4096]
owner ref check failed [1089167360 4096]
ref mismatch on [1089171456 4096] extent item 1, found 0
Backref 1089171456 root 1 not referenced back 0x1833170
Incorrect global backref count on 1089171456 found 1 wanted 0
backpointer mismatch on [1089171456 4096]
owner ref check failed [1089171456 4096]
ref mismatch on [1089183744 4096] extent item 1, found 0
Backref 1089183744 root 1 not referenced back 0x1864db0
Incorrect global backref count on 1089183744 found 1 wanted 0
backpointer mismatch on [1089183744 4096]
owner ref check failed [1089183744 4096]
ref mismatch on [1089187840 4096] extent item 1, found 0
Backref 1089187840 root 1 not referenced back 0x18332a0
Incorrect global backref count on 1089187840 found 1 wanted 0
backpointer mismatch on [1089187840 4096]
owner ref check failed [1089187840 4096]
ref mismatch on [1089191936 4096] extent item 1, found 0
Backref 1089191936 root 1 not referenced back 0x1864d80
Incorrect global backref count on 1089191936 found 1 wanted 0
backpointer mismatch on [1089191936 4096]
owner ref check failed [1089191936 4096]
ref mismatch on [1103101952 262144] extent item 1, found 0
Incorrect local backref count on 1103101952 root 1 owner 286 offset 0 found 0 wanted 1 back 0x185a8d0
backpointer mismatch on [1103101952 262144]
owner ref check failed [1103101952 262144]
ref mismatch on [1103364096 262144] extent item 1, found 0
Incorrect local backref count on 1103364096 root 1 owner 287 offset 0 found 0 wanted 1 back 0x1844b70
backpointer mismatch on [1103364096 262144]
owner ref check failed [1103364096 262144]
ref mismatch on [1103626240 262144] extent item 1, found 0
Incorrect local backref count on 1103626240 root 1 owner 288 offset 0 found 0 wanted 1 back 0x185aa00
backpointer mismatch on [1103626240 262144]
owner ref check failed [1103626240 262144]
ref mismatch on [1103888384 262144] extent item 1, found 0
Incorrect local backref count on 1103888384 root 1 owner 295 offset 0 found 0 wanted 1 back 0x1842b60
backpointer mismatch on [1103888384 262144]
owner ref check failed [1103888384 262144]
ref mismatch on [1104150528 262144] extent item 1, found 0
Incorrect local backref count on 1104150528 root 1 owner 290 offset 0 found 0 wanted 1 back 0x185ad90
backpointer mismatch on [1104150528 262144]
owner ref check failed [1104150528 262144]
ref mismatch on [1104412672 262144] extent item 1, found 0
Incorrect local backref count on 1104412672 root 1 owner 291 offset 0 found 0 wanted 1 back 0x185aff0
backpointer mismatch on [1104412672 262144]
owner ref check failed [1104412672 262144]
ref mismatch on [1104674816 262144] extent item 1, found 0
Incorrect local backref count on 1104674816 root 1 owner 292 offset 0 found 0 wanted 1 back 0x185b120
backpointer mismatch on [1104674816 262144]
owner ref check failed [1104674816 262144]
ref mismatch on [1104936960 262144] extent item 1, found 0
Incorrect local backref count on 1104936960 root 1 owner 293 offset 0 found 0 wanted 1 back 0x1844f00
backpointer mismatch on [1104936960 262144]
owner ref check failed [1104936960 262144]
ref mismatch on [1105199104 262144] extent item 1, found 0
Incorrect local backref count on 1105199104 root 1 owner 294 offset 0 found 0 wanted 1 back 0x185aec0
backpointer mismatch on [1105199104 262144]
owner ref check failed [1105199104 262144]
ref mismatch on [1105461248 262144] extent item 0, found 1
Backref 1105461248 root 1 owner 258 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1105461248 root 1 owner 258 offset 0 found 1 wanted 0 back 0x186dbf0
backpointer mismatch on [1105461248 262144]
ref mismatch on [1105985536 262144] extent item 1, found 0
Incorrect local backref count on 1105985536 root 1 owner 297 offset 0 found 0 wanted 1 back 0x1842310
backpointer mismatch on [1105985536 262144]
owner ref check failed [1105985536 262144]
ref mismatch on [1106247680 262144] extent item 1, found 0
Incorrect local backref count on 1106247680 root 1 owner 258 offset 0 found 0 wanted 1 back 0x185b250
backpointer mismatch on [1106247680 262144]
owner ref check failed [1106247680 262144]
ref mismatch on [1106509824 262144] extent item 0, found 1
Backref 1106509824 root 1 owner 259 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1106509824 root 1 owner 259 offset 0 found 1 wanted 0 back 0x186dcd0
backpointer mismatch on [1106509824 262144]
ref mismatch on [1106771968 262144] extent item 0, found 1
Backref 1106771968 root 1 owner 260 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1106771968 root 1 owner 260 offset 0 found 1 wanted 0 back 0x186ddb0
backpointer mismatch on [1106771968 262144]
ref mismatch on [1107034112 262144] extent item 0, found 1
Backref 1107034112 root 1 owner 261 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1107034112 root 1 owner 261 offset 0 found 1 wanted 0 back 0x186de90
backpointer mismatch on [1107034112 262144]
ref mismatch on [1107296256 262144] extent item 0, found 1
Backref 1107296256 root 1 owner 257 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1107296256 root 1 owner 257 offset 0 found 1 wanted 0 back 0x186db10
backpointer mismatch on [1107296256 262144]
ref mismatch on [1107558400 262144] extent item 0, found 1
Backref 1107558400 root 1 owner 262 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1107558400 root 1 owner 262 offset 0 found 1 wanted 0 back 0x185fae0
backpointer mismatch on [1107558400 262144]
ref mismatch on [1107820544 262144] extent item 0, found 1
Backref 1107820544 root 1 owner 263 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1107820544 root 1 owner 263 offset 0 found 1 wanted 0 back 0x185fb20
backpointer mismatch on [1107820544 262144]
ref mismatch on [1108082688 262144] extent item 0, found 1
Backref 1108082688 root 1 owner 264 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1108082688 root 1 owner 264 offset 0 found 1 wanted 0 back 0x186e0b0
backpointer mismatch on [1108082688 262144]
ref mismatch on [1108344832 262144] extent item 0, found 1
Backref 1108344832 root 1 owner 265 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1108344832 root 1 owner 265 offset 0 found 1 wanted 0 back 0x186e190
backpointer mismatch on [1108344832 262144]
ref mismatch on [1108606976 262144] extent item 0, found 1
Backref 1108606976 root 1 owner 266 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1108606976 root 1 owner 266 offset 0 found 1 wanted 0 back 0x186e270
backpointer mismatch on [1108606976 262144]
ref mismatch on [1108869120 262144] extent item 0, found 1
Backref 1108869120 root 1 owner 267 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1108869120 root 1 owner 267 offset 0 found 1 wanted 0 back 0x186e350
backpointer mismatch on [1108869120 262144]
ref mismatch on [1109131264 262144] extent item 0, found 1
Backref 1109131264 root 1 owner 268 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1109131264 root 1 owner 268 offset 0 found 1 wanted 0 back 0x186e430
backpointer mismatch on [1109131264 262144]
ref mismatch on [1109393408 262144] extent item 0, found 1
Backref 1109393408 root 1 owner 269 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1109393408 root 1 owner 269 offset 0 found 1 wanted 0 back 0x186e510
backpointer mismatch on [1109393408 262144]
ref mismatch on [1109655552 262144] extent item 0, found 1
Backref 1109655552 root 1 owner 270 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1109655552 root 1 owner 270 offset 0 found 1 wanted 0 back 0x186e5f0
backpointer mismatch on [1109655552 262144]
ref mismatch on [1109917696 262144] extent item 0, found 1
Backref 1109917696 root 1 owner 271 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1109917696 root 1 owner 271 offset 0 found 1 wanted 0 back 0x186e6d0
backpointer mismatch on [1109917696 262144]
ref mismatch on [1110179840 262144] extent item 0, found 1
Backref 1110179840 root 1 owner 272 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1110179840 root 1 owner 272 offset 0 found 1 wanted 0 back 0x186e7b0
backpointer mismatch on [1110179840 262144]
ref mismatch on [1110441984 262144] extent item 0, found 1
Backref 1110441984 root 1 owner 273 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1110441984 root 1 owner 273 offset 0 found 1 wanted 0 back 0x186e890
backpointer mismatch on [1110441984 262144]
ref mismatch on [1110704128 262144] extent item 0, found 1
Backref 1110704128 root 1 owner 274 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1110704128 root 1 owner 274 offset 0 found 1 wanted 0 back 0x186e970
backpointer mismatch on [1110704128 262144]
ref mismatch on [1110966272 262144] extent item 0, found 1
Backref 1110966272 root 1 owner 275 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1110966272 root 1 owner 275 offset 0 found 1 wanted 0 back 0x186ea50
backpointer mismatch on [1110966272 262144]
ref mismatch on [1111228416 262144] extent item 0, found 1
Backref 1111228416 root 1 owner 276 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1111228416 root 1 owner 276 offset 0 found 1 wanted 0 back 0x186eb30
backpointer mismatch on [1111228416 262144]
ref mismatch on [1111490560 262144] extent item 0, found 1
Backref 1111490560 root 1 owner 277 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1111490560 root 1 owner 277 offset 0 found 1 wanted 0 back 0x186ec10
backpointer mismatch on [1111490560 262144]
ref mismatch on [1111752704 262144] extent item 0, found 1
Backref 1111752704 root 1 owner 278 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1111752704 root 1 owner 278 offset 0 found 1 wanted 0 back 0x185fb60
backpointer mismatch on [1111752704 262144]
ref mismatch on [1112014848 262144] extent item 0, found 1
Backref 1112014848 root 1 owner 279 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1112014848 root 1 owner 279 offset 0 found 1 wanted 0 back 0x186ed90
backpointer mismatch on [1112014848 262144]
ref mismatch on [1112276992 262144] extent item 0, found 1
Backref 1112276992 root 1 owner 280 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1112276992 root 1 owner 280 offset 0 found 1 wanted 0 back 0x186ee70
backpointer mismatch on [1112276992 262144]
ref mismatch on [1112539136 262144] extent item 0, found 1
Backref 1112539136 root 1 owner 281 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1112539136 root 1 owner 281 offset 0 found 1 wanted 0 back 0x186ef50
backpointer mismatch on [1112539136 262144]
ref mismatch on [1112801280 262144] extent item 0, found 1
Backref 1112801280 root 1 owner 282 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1112801280 root 1 owner 282 offset 0 found 1 wanted 0 back 0x186f030
backpointer mismatch on [1112801280 262144]
ref mismatch on [1113063424 262144] extent item 0, found 1
Backref 1113063424 root 1 owner 283 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1113063424 root 1 owner 283 offset 0 found 1 wanted 0 back 0x186f110
backpointer mismatch on [1113063424 262144]
ref mismatch on [1113325568 262144] extent item 0, found 1
Backref 1113325568 root 1 owner 284 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1113325568 root 1 owner 284 offset 0 found 1 wanted 0 back 0x186f1f0
backpointer mismatch on [1113325568 262144]
ref mismatch on [1113587712 262144] extent item 0, found 1
Backref 1113587712 root 1 owner 285 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1113587712 root 1 owner 285 offset 0 found 1 wanted 0 back 0x186f2d0
backpointer mismatch on [1113587712 262144]
ref mismatch on [1113849856 262144] extent item 0, found 1
Backref 1113849856 root 1 owner 286 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1113849856 root 1 owner 286 offset 0 found 1 wanted 0 back 0x186f3b0
backpointer mismatch on [1113849856 262144]
ref mismatch on [1114112000 262144] extent item 0, found 1
Backref 1114112000 root 1 owner 287 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1114112000 root 1 owner 287 offset 0 found 1 wanted 0 back 0x186f490
backpointer mismatch on [1114112000 262144]
ref mismatch on [1114374144 262144] extent item 0, found 1
Backref 1114374144 root 1 owner 288 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1114374144 root 1 owner 288 offset 0 found 1 wanted 0 back 0x186f570
backpointer mismatch on [1114374144 262144]
ref mismatch on [1114636288 262144] extent item 0, found 1
Backref 1114636288 root 1 owner 289 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1114636288 root 1 owner 289 offset 0 found 1 wanted 0 back 0x186f650
backpointer mismatch on [1114636288 262144]
ref mismatch on [1114898432 262144] extent item 0, found 1
Backref 1114898432 root 1 owner 290 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1114898432 root 1 owner 290 offset 0 found 1 wanted 0 back 0x186f730
backpointer mismatch on [1114898432 262144]
ref mismatch on [1115160576 262144] extent item 0, found 1
Backref 1115160576 root 1 owner 291 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1115160576 root 1 owner 291 offset 0 found 1 wanted 0 back 0x186f810
backpointer mismatch on [1115160576 262144]
ref mismatch on [1115422720 262144] extent item 0, found 1
Backref 1115422720 root 1 owner 292 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1115422720 root 1 owner 292 offset 0 found 1 wanted 0 back 0x186f8f0
backpointer mismatch on [1115422720 262144]
ref mismatch on [1115684864 262144] extent item 0, found 1
Backref 1115684864 root 1 owner 293 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1115684864 root 1 owner 293 offset 0 found 1 wanted 0 back 0x185fba0
backpointer mismatch on [1115684864 262144]
ref mismatch on [1115947008 262144] extent item 0, found 1
Backref 1115947008 root 1 owner 294 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1115947008 root 1 owner 294 offset 0 found 1 wanted 0 back 0x186fa70
backpointer mismatch on [1115947008 262144]
ref mismatch on [1116209152 262144] extent item 0, found 1
Backref 1116209152 root 1 owner 295 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1116209152 root 1 owner 295 offset 0 found 1 wanted 0 back 0x186fb50
backpointer mismatch on [1116209152 262144]
ref mismatch on [1116471296 262144] extent item 0, found 1
Backref 1116471296 root 1 owner 297 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 1116471296 root 1 owner 297 offset 0 found 1 wanted 0 back 0x186fd10
backpointer mismatch on [1116471296 262144]
Errors found in extent allocation tree
checking fs roots
root 5 inode 18446744073709551604 errors 2000
root 5 inode 18446744073709551605 errors 1
found 1509789696 bytes used err is 1
total csum bytes: 1436724
total tree bytes: 1916928
total fs tree bytes: 8192
btree space waste bytes: 302283
file data blocks allocated: 1497092096
 referenced 1497092096
Btrfs Btrfs v0.19

--------------030302020901050409090004--

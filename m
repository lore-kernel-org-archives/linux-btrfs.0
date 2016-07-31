Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:46303 "EHLO
	syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbcGaANL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Jul 2016 20:13:11 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by syrinx.knorrie.org (Postfix) with ESMTPSA id A6092600A7
	for <linux-btrfs@vger.kernel.org>; Sun, 31 Jul 2016 02:13:06 +0200 (CEST)
Subject: Re: Balance and subvolume delete causes deadlock and metadata
 corruption
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <426e3db1-f06b-523a-be2c-261f47091f64@mendix.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <329413bd-0490-13bf-93db-3b495dfd5d7b@mendix.com>
Date: Sun, 31 Jul 2016 02:13:06 +0200
MIME-Version: 1.0
In-Reply-To: <426e3db1-f06b-523a-be2c-261f47091f64@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/31/2016 01:18 AM, Hans van Kranenburg wrote:
> blahblahblahblahblalahba
> 
> Doing a btrfs check now on the block device, will fup with the output.
> 

Output so far:

-# btrfs check /dev/xvdc 2>&1 | tee btrfs-check-xvdc
checking extents
ref mismatch on [3649516437504 16384] extent item 0, found 1
Backref 3649516437504 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [3649516437504 16384]
owner ref check failed [3649516437504 16384]
ref mismatch on [4091477114880 16384] extent item 0, found 1
Backref 4091477114880 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4091477114880 16384]
ref mismatch on [4092213280768 16384] extent item 0, found 1
Backref 4092213280768 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4092213280768 16384]
owner ref check failed [4092213280768 16384]
ref mismatch on [4093204430848 16384] extent item 0, found 1
Backref 4093204430848 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4093204430848 16384]
owner ref check failed [4093204430848 16384]
ref mismatch on [4093217013760 16384] extent item 0, found 1
Backref 4093217013760 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4093217013760 16384]
owner ref check failed [4093217013760 16384]
ref mismatch on [4093640835072 16384] extent item 0, found 1
Backref 4093640835072 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4093640835072 16384]
owner ref check failed [4093640835072 16384]
ref mismatch on [4094577901568 16384] extent item 0, found 1
Backref 4094577901568 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4094577901568 16384]
ref mismatch on [4095055790080 16384] extent item 0, found 1
Backref 4095055790080 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4095055790080 16384]
owner ref check failed [4095055790080 16384]
ref mismatch on [4095118868480 16384] extent item 0, found 1
Backref 4095118868480 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4095118868480 16384]
owner ref check failed [4095118868480 16384]
ref mismatch on [4095127683072 16384] extent item 0, found 1
Backref 4095127683072 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4095127683072 16384]
owner ref check failed [4095127683072 16384]
ref mismatch on [4095172657152 16384] extent item 0, found 1
Backref 4095172657152 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4095172657152 16384]
owner ref check failed [4095172657152 16384]
ref mismatch on [4095363858432 16384] extent item 0, found 1
Backref 4095363858432 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4095363858432 16384]
owner ref check failed [4095363858432 16384]
ref mismatch on [4095556337664 16384] extent item 0, found 1
Backref 4095556337664 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4095556337664 16384]
owner ref check failed [4095556337664 16384]
ref mismatch on [4095593791488 16384] extent item 0, found 1
Backref 4095593791488 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4095593791488 16384]
ref mismatch on [4095625068544 16384] extent item 0, found 1
Backref 4095625068544 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4095625068544 16384]
ref mismatch on [4095656804352 16384] extent item 0, found 1
Backref 4095656804352 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4095656804352 16384]
owner ref check failed [4095656804352 16384]
ref mismatch on [4095848955904 16384] extent item 0, found 1
Backref 4095848955904 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4095848955904 16384]
owner ref check failed [4095848955904 16384]
ref mismatch on [4095949471744 16384] extent item 0, found 1
Backref 4095949471744 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4095949471744 16384]
owner ref check failed [4095949471744 16384]
ref mismatch on [4095954468864 16384] extent item 0, found 1
Backref 4095954468864 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4095954468864 16384]
owner ref check failed [4095954468864 16384]
ref mismatch on [4095955189760 16384] extent item 0, found 1
Backref 4095955189760 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4095955189760 16384]
owner ref check failed [4095955189760 16384]
ref mismatch on [4096263684096 16384] extent item 0, found 1
Backref 4096263684096 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4096263684096 16384]
owner ref check failed [4096263684096 16384]
ref mismatch on [4096816726016 16384] extent item 0, found 1
Backref 4096816726016 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4096816726016 16384]
ref mismatch on [4096967491584 16384] extent item 0, found 1
Backref 4096967491584 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4096967491584 16384]
owner ref check failed [4096967491584 16384]
ref mismatch on [4097248460800 16384] extent item 0, found 1
Backref 4097248460800 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4097248460800 16384]
owner ref check failed [4097248460800 16384]
ref mismatch on [4097368129536 16384] extent item 0, found 1
Backref 4097368129536 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4097368129536 16384]
owner ref check failed [4097368129536 16384]
ref mismatch on [4097751973888 16384] extent item 0, found 1
Backref 4097751973888 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4097751973888 16384]
owner ref check failed [4097751973888 16384]
ref mismatch on [4097763704832 16384] extent item 0, found 1
Backref 4097763704832 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4097763704832 16384]
owner ref check failed [4097763704832 16384]
ref mismatch on [4098048196608 16384] extent item 0, found 1
Backref 4098048196608 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4098048196608 16384]
owner ref check failed [4098048196608 16384]
ref mismatch on [4098157133824 16384] extent item 0, found 1
Backref 4098157133824 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4098157133824 16384]
ref mismatch on [4098167603200 16384] extent item 0, found 1
Backref 4098167603200 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4098167603200 16384]
owner ref check failed [4098167603200 16384]
ref mismatch on [4098473148416 16384] extent item 0, found 1
Backref 4098473148416 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4098473148416 16384]
ref mismatch on [4098499313664 16384] extent item 0, found 1
Backref 4098499313664 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4098499313664 16384]
owner ref check failed [4098499313664 16384]
ref mismatch on [4098834153472 16384] extent item 0, found 1
Backref 4098834153472 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4098834153472 16384]
ref mismatch on [4099134046208 16384] extent item 0, found 1
Backref 4099134046208 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4099134046208 16384]
owner ref check failed [4099134046208 16384]
ref mismatch on [4099266510848 16384] extent item 0, found 1
Backref 4099266510848 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4099266510848 16384]
owner ref check failed [4099266510848 16384]
ref mismatch on [4099274964992 16384] extent item 0, found 1
Backref 4099274964992 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4099274964992 16384]
ref mismatch on [4099347021824 16384] extent item 0, found 1
Backref 4099347021824 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4099347021824 16384]
owner ref check failed [4099347021824 16384]
ref mismatch on [4099389947904 16384] extent item 0, found 1
Backref 4099389947904 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4099389947904 16384]
ref mismatch on [4099394666496 16384] extent item 0, found 1
Backref 4099394666496 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4099394666496 16384]
owner ref check failed [4099394666496 16384]
ref mismatch on [4099478274048 16384] extent item 0, found 1
Backref 4099478274048 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4099478274048 16384]
owner ref check failed [4099478274048 16384]
ref mismatch on [4099853582336 16384] extent item 0, found 1
Backref 4099853582336 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4099853582336 16384]
owner ref check failed [4099853582336 16384]
ref mismatch on [4099903537152 16384] extent item 0, found 1
Backref 4099903537152 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4099903537152 16384]
owner ref check failed [4099903537152 16384]
ref mismatch on [4099941236736 16384] extent item 0, found 1
Backref 4099941236736 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4099941236736 16384]
owner ref check failed [4099941236736 16384]
ref mismatch on [4100009459712 16384] extent item 0, found 1
Backref 4100009459712 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4100009459712 16384]
owner ref check failed [4100009459712 16384]
ref mismatch on [4100016357376 16384] extent item 0, found 1
Backref 4100016357376 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4100016357376 16384]
owner ref check failed [4100016357376 16384]
ref mismatch on [4100490805248 16384] extent item 0, found 1
Backref 4100490805248 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4100490805248 16384]
owner ref check failed [4100490805248 16384]
ref mismatch on [4100596203520 16384] extent item 0, found 1
Backref 4100596203520 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4100596203520 16384]
owner ref check failed [4100596203520 16384]
ref mismatch on [4100665131008 16384] extent item 0, found 1
Backref 4100665131008 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4100665131008 16384]
owner ref check failed [4100665131008 16384]
ref mismatch on [4100697374720 16384] extent item 0, found 1
Backref 4100697374720 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4100697374720 16384]
owner ref check failed [4100697374720 16384]
ref mismatch on [4100707680256 16384] extent item 0, found 1
Backref 4100707680256 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4100707680256 16384]
ref mismatch on [4100722114560 16384] extent item 0, found 1
Backref 4100722114560 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4100722114560 16384]
ref mismatch on [4100740890624 16384] extent item 0, found 1
Backref 4100740890624 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4100740890624 16384]
owner ref check failed [4100740890624 16384]
ref mismatch on [4100742070272 16384] extent item 0, found 1
Backref 4100742070272 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4100742070272 16384]
owner ref check failed [4100742070272 16384]
ref mismatch on [4100756652032 16384] extent item 0, found 1
Backref 4100756652032 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4100756652032 16384]
ref mismatch on [4100768907264 16384] extent item 0, found 1
Backref 4100768907264 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4100768907264 16384]
owner ref check failed [4100768907264 16384]
ref mismatch on [4100770611200 16384] extent item 0, found 1
Backref 4100770611200 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4100770611200 16384]
owner ref check failed [4100770611200 16384]
ref mismatch on [4100788355072 16384] extent item 0, found 1
Backref 4100788355072 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4100788355072 16384]
owner ref check failed [4100788355072 16384]
ref mismatch on [4100796071936 16384] extent item 0, found 1
Backref 4100796071936 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4100796071936 16384]
owner ref check failed [4100796071936 16384]
ref mismatch on [4100809228288 16384] extent item 0, found 1
Backref 4100809228288 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4100809228288 16384]
owner ref check failed [4100809228288 16384]
ref mismatch on [4100810686464 16384] extent item 0, found 1
Backref 4100810686464 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4100810686464 16384]
owner ref check failed [4100810686464 16384]
ref mismatch on [4100818829312 16384] extent item 0, found 1
Backref 4100818829312 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4100818829312 16384]
owner ref check failed [4100818829312 16384]
ref mismatch on [4100876222464 16384] extent item 0, found 1
Backref 4100876222464 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4100876222464 16384]
owner ref check failed [4100876222464 16384]
ref mismatch on [4101035114496 16384] extent item 0, found 1
Backref 4101035114496 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4101035114496 16384]
owner ref check failed [4101035114496 16384]
ref mismatch on [4101038145536 16384] extent item 0, found 1
Backref 4101038145536 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4101038145536 16384]
owner ref check failed [4101038145536 16384]
ref mismatch on [4101042978816 16384] extent item 0, found 1
Backref 4101042978816 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4101042978816 16384]
ref mismatch on [4101069209600 16384] extent item 0, found 1
Backref 4101069209600 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4101069209600 16384]
ref mismatch on [4101199069184 16384] extent item 0, found 1
Backref 4101199069184 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4101199069184 16384]
ref mismatch on [4101233442816 16384] extent item 0, found 1
Backref 4101233442816 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4101233442816 16384]
owner ref check failed [4101233442816 16384]
ref mismatch on [4101280694272 16384] extent item 0, found 1
Backref 4101280694272 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4101280694272 16384]
owner ref check failed [4101280694272 16384]
ref mismatch on [4101286248448 16384] extent item 0, found 1
Backref 4101286248448 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4101286248448 16384]
owner ref check failed [4101286248448 16384]
ref mismatch on [4101352767488 16384] extent item 0, found 1
Backref 4101352767488 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4101352767488 16384]
ref mismatch on [4101372133376 16384] extent item 0, found 1
Backref 4101372133376 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4101372133376 16384]
ref mismatch on [4101387141120 16384] extent item 0, found 1
Backref 4101387141120 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4101387141120 16384]
owner ref check failed [4101387141120 16384]
ref mismatch on [4101463506944 16384] extent item 0, found 1
Backref 4101463506944 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4101463506944 16384]
owner ref check failed [4101463506944 16384]
ref mismatch on [4101494669312 16384] extent item 0, found 1
Backref 4101494669312 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4101494669312 16384]
owner ref check failed [4101494669312 16384]
ref mismatch on [4101508988928 16384] extent item 0, found 1
Backref 4101508988928 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4101508988928 16384]
ref mismatch on [4101608783872 16384] extent item 0, found 1
Backref 4101608783872 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4101608783872 16384]
owner ref check failed [4101608783872 16384]
ref mismatch on [4101768429568 16384] extent item 0, found 1
Backref 4101768429568 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4101768429568 16384]
owner ref check failed [4101768429568 16384]
ref mismatch on [4101836734464 16384] extent item 0, found 1
Backref 4101836734464 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4101836734464 16384]
owner ref check failed [4101836734464 16384]
ref mismatch on [4102052282368 16384] extent item 0, found 1
Backref 4102052282368 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4102052282368 16384]
owner ref check failed [4102052282368 16384]
ref mismatch on [4102060163072 16384] extent item 0, found 1
Backref 4102060163072 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4102060163072 16384]
owner ref check failed [4102060163072 16384]
ref mismatch on [4102357254144 16384] extent item 0, found 1
Backref 4102357254144 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4102357254144 16384]
ref mismatch on [4102390448128 16384] extent item 0, found 1
Backref 4102390448128 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4102390448128 16384]
owner ref check failed [4102390448128 16384]
ref mismatch on [4102436552704 16384] extent item 0, found 1
Backref 4102436552704 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4102436552704 16384]
ref mismatch on [4102542409728 16384] extent item 0, found 1
Backref 4102542409728 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4102542409728 16384]
ref mismatch on [4102570328064 16384] extent item 0, found 1
Backref 4102570328064 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4102570328064 16384]
owner ref check failed [4102570328064 16384]
ref mismatch on [4102596214784 16384] extent item 0, found 1
Backref 4102596214784 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4102596214784 16384]
owner ref check failed [4102596214784 16384]
ref mismatch on [4102602211328 16384] extent item 0, found 1
Backref 4102602211328 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4102602211328 16384]
owner ref check failed [4102602211328 16384]
ref mismatch on [4102619987968 16384] extent item 0, found 1
Backref 4102619987968 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4102619987968 16384]
owner ref check failed [4102619987968 16384]
ref mismatch on [4102647250944 16384] extent item 0, found 1
Backref 4102647250944 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4102647250944 16384]
owner ref check failed [4102647250944 16384]
ref mismatch on [4102656671744 16384] extent item 0, found 1
Backref 4102656671744 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4102656671744 16384]
owner ref check failed [4102656671744 16384]
ref mismatch on [4102712262656 16384] extent item 0, found 1
Backref 4102712262656 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4102712262656 16384]
ref mismatch on [4102725844992 16384] extent item 0, found 1
Backref 4102725844992 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4102725844992 16384]
owner ref check failed [4102725844992 16384]
ref mismatch on [4102753697792 16384] extent item 0, found 1
Backref 4102753697792 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4102753697792 16384]
ref mismatch on [4102836191232 16384] extent item 0, found 1
Backref 4102836191232 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4102836191232 16384]
ref mismatch on [4102879494144 16384] extent item 0, found 1
Backref 4102879494144 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4102879494144 16384]
owner ref check failed [4102879494144 16384]
ref mismatch on [4102886178816 16384] extent item 0, found 1
Backref 4102886178816 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4102886178816 16384]
ref mismatch on [4102909345792 16384] extent item 0, found 1
Backref 4102909345792 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4102909345792 16384]
owner ref check failed [4102909345792 16384]
ref mismatch on [4102909935616 16384] extent item 0, found 1
Backref 4102909935616 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4102909935616 16384]
ref mismatch on [4102912491520 16384] extent item 0, found 1
Backref 4102912491520 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4102912491520 16384]
owner ref check failed [4102912491520 16384]
ref mismatch on [4102920224768 16384] extent item 0, found 1
Backref 4102920224768 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4102920224768 16384]
ref mismatch on [4102943899648 16384] extent item 0, found 1
Backref 4102943899648 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4102943899648 16384]
ref mismatch on [4103072169984 16384] extent item 0, found 1
Backref 4103072169984 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4103072169984 16384]
ref mismatch on [4103170441216 16384] extent item 0, found 1
Backref 4103170441216 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4103170441216 16384]
ref mismatch on [4103180943360 16384] extent item 0, found 1
Backref 4103180943360 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4103180943360 16384]
ref mismatch on [4103253852160 16384] extent item 0, found 1
Backref 4103253852160 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4103253852160 16384]
owner ref check failed [4103253852160 16384]
ref mismatch on [4103282835456 16384] extent item 0, found 1
Backref 4103282835456 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4103282835456 16384]
owner ref check failed [4103282835456 16384]
ref mismatch on [4103298596864 16384] extent item 0, found 1
Backref 4103298596864 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4103298596864 16384]
ref mismatch on [4103299760128 16384] extent item 0, found 1
Backref 4103299760128 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4103299760128 16384]
owner ref check failed [4103299760128 16384]
ref mismatch on [4103314554880 16384] extent item 0, found 1
Backref 4103314554880 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4103314554880 16384]
owner ref check failed [4103314554880 16384]
ref mismatch on [4103318978560 16384] extent item 0, found 1
Backref 4103318978560 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4103318978560 16384]
owner ref check failed [4103318978560 16384]
ref mismatch on [4103351107584 16384] extent item 0, found 1
Backref 4103351107584 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4103351107584 16384]
owner ref check failed [4103351107584 16384]
ref mismatch on [4103358775296 16384] extent item 0, found 1
Backref 4103358775296 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4103358775296 16384]
owner ref check failed [4103358775296 16384]
ref mismatch on [4103373160448 16384] extent item 0, found 1
Backref 4103373160448 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4103373160448 16384]
ref mismatch on [4103438221312 16384] extent item 0, found 1
Backref 4103438221312 parent 4100606377984 root 4100606377984 not found
in extent tree
backpointer mismatch on [4103438221312 16384]
owner ref check failed [4103438221312 16384]
checking free space tree
checking fs roots
[...]

-- 
Hans van Kranenburg - System / Network Engineer
T +31 (0)10 2760434 | hans.van.kranenburg@mendix.com | www.mendix.com

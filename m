Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59841 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaLSJ5k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 04:57:40 -0500
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 55AAE3EE188
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 18:57:39 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 64AF1AC078A
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 18:57:38 +0900 (JST)
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id C4860E08003
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 18:57:37 +0900 (JST)
Message-ID: <5493F65B.5080603@jp.fujitsu.com>
Date: Fri, 19 Dec 2014 18:56:43 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/6] btrfs-progs: fi usage, update manpage
References: <cover.1418912740.git.dsterba@suse.cz> <488c53a0e5e255f9504cfc2a029e7c1c72994f66.1418912740.git.dsterba@suse.cz> <5493B1F8.2070106@jp.fujitsu.com>
In-Reply-To: <5493B1F8.2070106@jp.fujitsu.com>
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

> On 2014/12/18 23:27, David Sterba wrote:
>> Signed-off-by: David Sterba <dsterba@suse.cz>
>> ---
>>    Documentation/btrfs-filesystem.txt | 28 ++++++++++++++++++++++++++++
>>    1 file changed, 28 insertions(+)
>>
>> diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
>> index a8f2972a0e1a..85a94eb52569 100644
>> --- a/Documentation/btrfs-filesystem.txt
>> +++ b/Documentation/btrfs-filesystem.txt
>> @@ -123,6 +123,34 @@ Show or update the label of a filesystem.
>>    If a newlabel optional argument is passed, the label is changed.
>>    NOTE: the maximum allowable length shall be less than 256 chars
>>    
>> +*usage* [options] <path> [<path>...]::
>> +Show detailed information about internal filesystem usage.
> 
> Options from "-b" to "-t" are the completely same as "btrfs fi df"'s ones.
> So how about pointing the df's options as follows?
> 
> ===============================================================================
> ...
> +
> `Options`
> +
> -T::::
> Show data in tabular format
> +
> There are some option to set unit. See description of *df*'s options
> from '-b' to '-t'.
> +
> If conflicting options are passed, the last one takes precedence.
> ...
> ===============================================================================
> 
> I consider it can prevent mistakes caused by further changes.

This patch seems to already be in devel/integration-20141218.
Here is the patch example.


---
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: Cleanup: Fix the redundancy of btrfs-filesystem.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

---
 Documentation/btrfs-filesystem.txt | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
index 85a94eb..a8e7431 100644
--- a/Documentation/btrfs-filesystem.txt
+++ b/Documentation/btrfs-filesystem.txt
@@ -128,27 +128,12 @@ Show detailed information about internal filesystem usage.
 +
 `Options`
 +
--b|--raw::::
-raw numbers in bytes, without the 'B' suffix
--h::::
-print human friendly numbers, base 1024, this is the default
--H::::
-print human friendly numbers, base 1000
---iec::::
-select the 1024 base for the following options, according to the IEC standard
---si::::
-select the 1000 base for the following options, according to the SI standard
--k|--kbytes::::
-show sizes in KiB, or kB with --si
--m|--mbytes::::
-show sizes in MiB, or MB with --si
--g|--gbytes::::
-show sizes in GiB, or GB with --si
--t|--tbytes::::
-show sizes in TiB, or TB with --si
 -T::::
 show data in tabular format
 
+There are some options to set unit. See the description of *df* subcommand
+from '-b' option to '-t' option.
+
 If conflicting options are passed, the last one takes precedence.
 
 EXIT STATUS
-- 
1.8.3.1


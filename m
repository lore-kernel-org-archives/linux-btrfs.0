Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.automatix.de ([213.131.255.221]:54609 "EHLO
	mail.automatix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbbIPJKG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 05:10:06 -0400
Subject: Re: Recovery possible on asynchronous transid ?
To: Hugo Mills <hugo@carfax.org.uk>, service@automatix.de,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <55F82990.5050403@automatix.de>
 <20150915155547.GB28645@carfax.org.uk>
From: Juergen Sauer <juergen.sauer@automatix.de>
Message-ID: <55F931EC.70902@automatix.de>
Date: Wed, 16 Sep 2015 11:10:04 +0200
MIME-Version: 1.0
In-Reply-To: <20150915155547.GB28645@carfax.org.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 15.09.2015 um 17:55 schrieb Hugo Mills:
> On Tue, Sep 15, 2015 at 04:22:08PM +0200, Juergen Sauer wrote:

>> Due an hibernation event my BTRFS Raid56 failed and is not mountable
>> anymore. :(

>> For Debugging I moved the Devices to an test-hardware and booted this
>> system from an Arch Linux ISO, which I created for this purpose.

>> The Problem is:
>> [ 1086.714109] BTRFS (device sdd1): parent transid verify failed on
>> 209362944 wanted 293924 found 293922

>    Try mounting with -o recovery, and see if that helps.

Looks bad, does not really work:
[68928.031733] BTRFS info (device sdd1): enabling auto recovery
[68928.031737] BTRFS info (device sdd1): disk space caching is enabled
[68928.054066] BTRFS (device sdd1): parent transid verify failed on
209362944 wanted 293924 found 293922
[68928.069521] BTRFS (device sdd1): parent transid verify failed on
244719616 wanted 293924 found 293922
[68928.071678] BTRFS: bdev /dev/sdb1 errs: wr 3, rd 0, flush 1, corrupt
0, gen 0
[68928.072003] BTRFS (device sdd1): parent transid verify failed on
209375232 wanted 293924 found 293914
[68928.080334] BTRFS (device sdd1): parent transid verify failed on
245538816 wanted 293924 found 293922
[68928.123135] BTRFS (device sdd1): parent transid verify failed on
253378560 wanted 293924 found 293914
[68928.145374] BTRFS (device sdd1): parent transid verify failed on
253390848 wanted 293924 found 293914
[68928.146821] BTRFS (device sdd1): parent transid verify failed on
253403136 wanted 293924 found 293914
[68928.261550] BTRFS (device sdd1): parent transid verify failed on
253911040 wanted 293924 found 293914
[68928.263319] BTRFS (device sdd1): bad tree block start 0 253911040

I think, it could hel to be able to choose a special transid or to work
read-only on an special older transid, i.e. 'transid: 293914' ?

But how to do that?

Or may it help to remove an device out of raid56 cluster?


mit freundlichen Grüßen
Jürgen Sauer
-- 
Jürgen Sauer - automatiX GmbH,
+49-4209-4699, juergen.sauer@automatix.de
Geschäftsführer: Jürgen Sauer,
Gerichtstand: Amtsgericht Walsrode • HRB 120986
Ust-Id: DE191468481 • St.Nr.: 36/211/08000
GPG Public Key zur Signaturprüfung:
http://www.automatix.de/juergen_sauer_publickey.gpg

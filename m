Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:35225 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaLCCcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 21:32:53 -0500
Received: by mail-qc0-f175.google.com with SMTP id b13so11625944qcw.6
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 18:32:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141202083419.GK32735@carfax.org.uk>
References: <CAH-HCWVcu9FW0c3zwEg_KR_yaPGRQ58yHbXsUx1JCKRu4s7NXQ@mail.gmail.com>
 <CAJCQCtT3EeGUOpZ9q78BcWv_Cc_5UGY=uPVJX+bqex9Zo_bWYg@mail.gmail.com>
 <CAH-HCWUSX+N2Byo4vpCxac89TSX2YGoP39VgFsq6952k9V9cmQ@mail.gmail.com> <20141202083419.GK32735@carfax.org.uk>
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Wed, 3 Dec 2014 08:02:31 +0530
Message-ID: <CAH-HCWV_EhhQ11UT4Ysb0OT4tJfmEuWBek_z8MPeHwBZ0R7H3Q@mail.gmail.com>
Subject: Re: Moving an entire subvol?
To: Hugo Mills <hugo@carfax.org.uk>, Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 2, 2014 at 2:04 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>
>> Is that correct: what btr sub list shows as "top level" is indeed the
>> parent subvolume?
>
>    No, it's the top-level subvolume. (See my earlier mail about
> nomenclature). "Parent subvolume" has a number of meanings, none of
> which should be "the subvolume with subvolid 5".

Um I searched my inbox but didn't find a specific definition from you
for "top-level". You only said it's better to avoid calling it "root"
to avoid confounding it with the subvol that may be mounted at root
i.e. /.

IIUC the "top-level subvolume" can only be subvolid 5 which accords
with your later comment:

> that putting files in the top-level subvol can't do what most people
> want to do with it. Hence the recommended subvol management layout at
> [1] https://btrfs.wiki.kernel.org/index.php/SysadminGuide#Subvolumes

... which means that I am not able to understand the output of btr sub
list which gives the subvolid of whichever subvol is currently the
"parent" (as in outer nesting) subvol. Observe:

$ btr sub list .
ID 257 gen 10 top level 5 path test1
ID 258 gen 10 top level 5 path test2
ID 259 gen 9 top level 258 path test2/foo
$ sudo mv test2/foo test1/
$ btr sub list .
ID 257 gen 10 top level 5 path test1
ID 258 gen 10 top level 5 path test2
ID 259 gen 9 top level 257 path test1/foo
$

So now what is the meaning of "top level"?

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा

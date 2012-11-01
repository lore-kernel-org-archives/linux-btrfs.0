Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:51727 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760315Ab2KAXEQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Nov 2012 19:04:16 -0400
Message-ID: <5093001B.9080009@inwind.it>
Date: Fri, 02 Nov 2012 00:04:59 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: "Fajar A. Nugraha" <list@fajar.net>
CC: cwillu <cwillu@cwillu.com>, Anand jain <Anand.Jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [Request for review] [RFC] Add label support for snapshots and
 subvols
References: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com> <CAE5mzvjJmYGJvgjBGLv8kaUnZPDZu_QaU5s1=mYo55RmujeDNQ@mail.gmail.com> <CAG1y0sd-F6WrUFsvwAx+7LGD+V7a6XCoP9=XEkADPEAyEL1G1w@mail.gmail.com>
In-Reply-To: <CAG1y0sd-F6WrUFsvwAx+7LGD+V7a6XCoP9=XEkADPEAyEL1G1w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/01/2012 11:28 PM, Fajar A. Nugraha wrote:
> On Fri, Nov 2, 2012 at 5:16 AM, cwillu <cwillu@cwillu.com> wrote:
>>>  btrfs fi label -t /btrfs/snap1-sv1
>>> Prod-DB-sand-box-testing
>>
>> Why is this better than:
>>
>> # btrfs su snap /btrfs/Prod-DB /btrfs/Prod-DB-sand-box-testing
>> # mv /btrfs/Prod-DB-sand-box-testing /btrfs/Prod-DB-production-test
>> # ls /btrfs/
>> Prod-DB  Prod-DB-production-test
> 
> 
> ... because it would mean possibilty to decouple subvol name from
> whatever-data-you-need (in this case, a label).
> 

Could you elaborate how this solution is different from using xattr ?
I think also that these labels could be changed (like xattr). ?

These info should be associated to the inode of the subvolume root. We
could use a specific name in the system namespace, like
"system.btrfslabel" even tough I didn't see any advantage to using the
"user" namespace...


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

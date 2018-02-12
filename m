Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bl2nam02on0078.outbound.protection.outlook.com ([104.47.38.78]:28238
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753044AbeBLPg6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 10:36:58 -0500
Subject: Re: btrfs-cleaner / snapshot performance analysis
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Tomasz Pala <gotar@polanet.pl>
Cc: linux-btrfs@vger.kernel.org
References: <346220b8-d129-1de9-eb28-6344ec0b0d3a@panasas.com>
 <96cd9e57-cde4-5bc4-0312-02b54668e59a@mendix.com>
 <76e7f364-62b9-5ef1-a8ed-f6fb9e534963@panasas.com>
 <20180210220549.GA30438@polanet.pl>
 <6abc187c-b5fe-a776-6b89-ca5b6c7ee790@panasas.com>
 <20c617b6-7179-a67a-3997-8fee766088a5@mendix.com>
From: "Ellis H. Wilson III" <ellisw@panasas.com>
Message-ID: <c7e267a4-d47d-9713-c222-81dcb441e009@panasas.com>
Date: Mon, 12 Feb 2018 10:37:02 -0500
MIME-Version: 1.0
In-Reply-To: <20c617b6-7179-a67a-3997-8fee766088a5@mendix.com>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/11/2018 01:24 PM, Hans van Kranenburg wrote:
> Why not just use `btrfs fi du <subvol> <snap1> <snap2>` now and then and
> update your administration with the results? .. Instead of putting the
> burden of keeping track of all administration during every tiny change
> all day long?

I will look into that if using built-in group capacity functionality 
proves to be truly untenable.  Thanks!

>> CoW is still valuable for us as we're shooting to support on the order
>> of hundreds of snapshots per subvolume,
> 
> Hundreds will get you into trouble even without qgroups.

I should have been more specific.  We are looking to use up to a few 
dozen snapshots per subvolume, but will have many (tens to hundreds of) 
discrete subvolumes (each with up to a few dozen snapshots) in a BTRFS 
filesystem.  If I have it wrong and the scalability issues in BTRFS do 
not solely apply to subvolumes and their snapshot counts, please let me 
know.

I will note you focused on my tiny desktop filesystem when making some 
of your previous comments -- this is why I didn't want to share specific 
details.  Our filesystem will be RAID0 with six large HDDs (12TB each). 
Reliability concerns do not apply to our situation for technical 
reasons, but if there are capacity scaling issues with BTRFS I should be 
made aware of, I'd be glad to hear them.  I have not seen any in 
technical documentation of such a limit, and experiments so far on 6x6TB 
arrays has not shown any performance problems, so I'm inclined to 
believe the only scaling issue exists with reflinks.  Correct me if I'm 
wrong.

Thanks,

ellis

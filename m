Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www44.your-server.de ([213.133.104.44]:53497 "EHLO
        www44.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751467AbdDRNfd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Apr 2017 09:35:33 -0400
Subject: Re: btrfs check --check-data-csum malfunctioning?
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
References: <4b1b08de-9012-fb2a-eca1-a8adfdbf8e7b@o3-software.de>
 <20170418131506.GJ21462@carfax.org.uk>
From: Werner Braun <wb@o3-software.de>
Message-ID: <bb9ad7b6-8b5c-200c-4e5a-4050a7543f63@o3-software.de>
Date: Tue, 18 Apr 2017 15:35:31 +0200
MIME-Version: 1.0
In-Reply-To: <20170418131506.GJ21462@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 18.04.2017 15:15, Hugo Mills wrote:
> On Tue, Apr 18, 2017 at 02:41:49PM +0200, Werner Braun wrote:
>> Hi,
>>
>> i have a WD WD40EZRX with strange beaviour off btrfs check vs. btrfs scrub
>>
>> running btrfs check --check-data-csum returns no errors on the disk
>>
>> running btrfs scrub on the disk finds tons of errors
>>
>> i could clear the disk and send it to anyone intrested in ;-)
>
>    Do you have anything likely to be writing with O_DIRECT during the
> scrub? Specifically, databases and VMs. Possibly some kinds of
> torrent/distributed downloads.

No i used as a temporary disk for btrfs send receive,
btrfs send -v -f /mnt/tmp/out <subvol>
wrote 1.5 TB of Data.

while running
btrfs receive -v -f /mnt/tmp/out /path/to/dest

read errors occured

I called

btrfs check --check-data-csum

which returned no errors

then i mounted the Disk and called

btrfs scrub start /path/to/dest

No other read or write operations where running on the disk at that time.



-- 
Werner Braun
+49 178 145 8768

O³ Software GmbH & Co. KG * Franziusallee 73 * 24148 Kiel * Germany
Sitz der Gesellschaft Kiel * HR Amtsgericht Kiel HRA 6418 KI
Persönlich haftende Gesellschafterin: O³ Software GmbH
HR Amtsgericht Kiel HRB 10335 KI * Geschäftsführer Werner Braun

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:35574 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbbEKVX6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 17:23:58 -0400
Received: by igbyr2 with SMTP id yr2so83625402igb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 14:23:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55510B14.7090204@friedels.name>
References: <55510B14.7090204@friedels.name>
Date: Mon, 11 May 2015 14:23:58 -0700
Message-ID: <CAN05THRAVfb6vo2eLvdO-wvFL5--4xR+g6uQVsmGd2AEr0bxPw@mail.gmail.com>
Subject: Re: raid 5 and different device size
From: ronnie sahlberg <ronniesahlberg@gmail.com>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For that kind of data where you mainly store lots of (big?) files but
rarely modify the files once stored,
I would suggest using snapraid  it is mor stable and reliable than
current btrfs raid5 state.
And it allows you to to go to raid6 and beyond as your data and
redundancy factors grow.


On Mon, May 11, 2015 at 1:03 PM, Hendrik Friedel <hendrik@friedels.name> wrote:
> Hello,
>
> I need your advice for the following scenario:
> I do have three -identical- 3TB HDD. On these I store:
> -Backups (Images of my Families Laptop; Backup of the Machines (the one with
> the HDD) running System).
> -Videos (recordings, not essential)
> -HomeVideos (Familiy, essential)
> -Photos
> -Documents
>
> Now I intend to:
> * increase the available disc space
> * stop worrying how much space is available on which drive
> * create redundancy
> * have low operating cost (power-consumption)
>
>
> So, I need to buy one additional HDD.
> And I want to combine the drives to one big volume.
>
> I am aware that raid is no backup.
> Thus, I backup the HomeVideos and the Photos on an external drive not
> connected to the power supply and USB.
>
> I think, that I do not need raid5, depending on the definition of 'not
> essential'. Nevertheless, raid5 would efficiently (at low cost) decrease the
> likelyhood of loss of the 'non-essential' data.
> Furthermore, raid5 would fill the gap that I have between backups (the fact,
> that I do these backup manually means that I do not do them every day) and
> at least safe me from hardware failures.
>
> So, yes, I think I do want raid5 and I want to combine.
> But what size of HDD do I want to buy? The best value (cost per TB) I get
> for 3TB drives. So I could by two 3TB drives, one for additional space, the
> other for the parity information.
> Or I could by one bigger drive, with potentially lower power consumption.
> But how would the raid5 look in this case? I fear, only 3TB of the 6 would
> be redundant and the other 3 would be not redundant, right?
>
>
> Now the last point: Power consumption: Under which conditions can the drives
> spin down in case of raid5? I assume that all drives have to run as in case
> the data is written on any one of the drives, right?
> Is that also true during reading of data, i.e. is the parity also checked
> for read operations?
>
> Thanks for your advice in advance,
> Hendrik
>
>
>
>
>
> ---
> Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
> http://www.avast.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

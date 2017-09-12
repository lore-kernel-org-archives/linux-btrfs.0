Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:45895 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751304AbdILDTv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 23:19:51 -0400
Received: by mail-wm0-f47.google.com with SMTP id f199so52019691wme.0
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 20:19:50 -0700 (PDT)
Subject: Re: send | receive: received snapshot is missing recent files
To: Axel Burri <axel@tty0.ch>, Dave <davestechshop@gmail.com>,
        linux-btrfs@vger.kernel.org
Cc: A L <crimsoncottage@gmail.com>
References: <CAH=dxU6uVGXbdYc_65P6XbSby76A6Y=qoM6=cXMHkWDV8JRHVg@mail.gmail.com>
 <CAH=dxU7RM7s+pxT=wxE9WcUNMWjSG_A0=1pUWD1dWGVQ6g+g8Q@mail.gmail.com>
 <CAH=dxU6xwikfvfY7zCfuPavnCMMdecnyPckOZ3nyYm+_PZtOrg@mail.gmail.com>
 <CAH=dxU6kQdqp-x0nLbTk=T8VhgH3oX8UUA_BO4p6rLEmwBsHhQ@mail.gmail.com>
 <b899f57.51efafb1.15e5b02df03@gmail.com>
 <CAH=dxU4T8zB3ufn8JC1Jq0-QXkCnWt11NkXBLNBQnEi3RA1PDQ@mail.gmail.com>
 <CAH=dxU6S7XLVb4NY0ueZapUJW6A_KM9JezpB3icjYW4nRB8OPA@mail.gmail.com>
 <e9ec7ac7-781d-34e0-9f48-aeb8566e5787@tty0.ch>
 <CAH=dxU7Qtfqq1nT1cm8nS+OG-0GRZdtNEj2wSt4N6aoQ7f8YUQ@mail.gmail.com>
 <0f1e32f8-12c7-4aa7-246f-4f6805e6d3df@tty0.ch>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <f7adba0b-9464-0d75-28f3-3b90187ee14e@gmail.com>
Date: Tue, 12 Sep 2017 06:19:48 +0300
MIME-Version: 1.0
In-Reply-To: <0f1e32f8-12c7-4aa7-246f-4f6805e6d3df@tty0.ch>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

11.09.2017 20:53, Axel Burri пишет:
> On 2017-09-08 06:44, Dave wrote:
>> I'm referring to the link below. Using "btrfs subvolume snapshot -r"
>> copies the Received UUID from the source into the new snapshot. The
>> btrbk FAQ entry suggests otherwise. Has something changed?
> 
> I don't think something has changed, the description for the read-only
> subvolumes on the btrbk FAQ was just wrong (fixed now).
> 
>> The only way I see to remove a Received UUID is to create a rw
>> snapshot (above command without the "-r"), which is not ideal in this
>> situation when cleaning up readonly source snapshots.
>>
>> Any suggestions? Thanks
> 
> No suggestions from my part, as far as I know there is no way to easily
> remove/change a received_uuid from a subvolume.
> 

There is BTRFS_IOC_SET_RECEIVED_SUBVOL IOCTL which is used by "btrfs
received". My understanding is that it can also be set to empty (this
clearing it). You could write small program to do it.

In general it sounds like a bug - removing read-only flag from subvolume
by any means should also clear Received UUID as we cannot anymore
guarantee that subvolume content is the same.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:44376 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751052AbdIMQxJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 12:53:09 -0400
Received: by mail-io0-f182.google.com with SMTP id v36so4376383ioi.1
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Sep 2017 09:53:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f7adba0b-9464-0d75-28f3-3b90187ee14e@gmail.com>
References: <CAH=dxU6uVGXbdYc_65P6XbSby76A6Y=qoM6=cXMHkWDV8JRHVg@mail.gmail.com>
 <CAH=dxU7RM7s+pxT=wxE9WcUNMWjSG_A0=1pUWD1dWGVQ6g+g8Q@mail.gmail.com>
 <CAH=dxU6xwikfvfY7zCfuPavnCMMdecnyPckOZ3nyYm+_PZtOrg@mail.gmail.com>
 <CAH=dxU6kQdqp-x0nLbTk=T8VhgH3oX8UUA_BO4p6rLEmwBsHhQ@mail.gmail.com>
 <b899f57.51efafb1.15e5b02df03@gmail.com> <CAH=dxU4T8zB3ufn8JC1Jq0-QXkCnWt11NkXBLNBQnEi3RA1PDQ@mail.gmail.com>
 <CAH=dxU6S7XLVb4NY0ueZapUJW6A_KM9JezpB3icjYW4nRB8OPA@mail.gmail.com>
 <e9ec7ac7-781d-34e0-9f48-aeb8566e5787@tty0.ch> <CAH=dxU7Qtfqq1nT1cm8nS+OG-0GRZdtNEj2wSt4N6aoQ7f8YUQ@mail.gmail.com>
 <0f1e32f8-12c7-4aa7-246f-4f6805e6d3df@tty0.ch> <f7adba0b-9464-0d75-28f3-3b90187ee14e@gmail.com>
From: Dave <davestechshop@gmail.com>
Date: Wed, 13 Sep 2017 12:52:48 -0400
Message-ID: <CAH=dxU5NqUxuWffdca1ft4FmE+hhu5ho0Fc04SQhdLvBA0ynXw@mail.gmail.com>
Subject: Re: send | receive: received snapshot is missing recent files
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Axel Burri <axel@tty0.ch>, linux-btrfs@vger.kernel.org,
        A L <crimsoncottage@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 11, 2017 at 11:19 PM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> 11.09.2017 20:53, Axel Burri пишет:
>> On 2017-09-08 06:44, Dave wrote:
>>> I'm referring to the link below. Using "btrfs subvolume snapshot -r"
>>> copies the Received UUID from the source into the new snapshot. The
>>> btrbk FAQ entry suggests otherwise. Has something changed?
>>
>> I don't think something has changed, the description for the read-only
>> subvolumes on the btrbk FAQ was just wrong (fixed now).
>>
>>> The only way I see to remove a Received UUID is to create a rw
>>> snapshot (above command without the "-r"), which is not ideal in this
>>> situation when cleaning up readonly source snapshots.
>>>
>>> Any suggestions? Thanks
>>
>> No suggestions from my part, as far as I know there is no way to easily
>> remove/change a received_uuid from a subvolume.
>>
>
> There is BTRFS_IOC_SET_RECEIVED_SUBVOL IOCTL which is used by "btrfs
> received". My understanding is that it can also be set to empty (this
> clearing it). You could write small program to do it.
>
> In general it sounds like a bug - removing read-only flag from subvolume
> by any means should also clear Received UUID as we cannot anymore
> guarantee that subvolume content is the same.

Yes! That makes a great deal of sense.

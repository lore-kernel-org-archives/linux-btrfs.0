Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:53154 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbaDDQBn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Apr 2014 12:01:43 -0400
Received: by mail-lb0-f171.google.com with SMTP id w7so2643115lbi.16
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Apr 2014 09:01:41 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140404155346.GX29256@twin.jikos.cz>
References: <1396624841-1363-1-git-send-email-fdmanana@gmail.com>
	<20140404155346.GX29256@twin.jikos.cz>
Date: Fri, 4 Apr 2014 17:01:41 +0100
Message-ID: <CAL3q7H5V1OjW8nerpCuNUB+8FhjPV+4hXPQf81QBtU3PQypgjQ@mail.gmail.com>
Subject: Re: [RFC PATCH] Btrfs: send, add calculate data size flag to allow
 for progress estimation
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 4, 2014 at 4:53 PM, David Sterba <dsterba@suse.cz> wrote:
> On Fri, Apr 04, 2014 at 04:20:41PM +0100, Filipe David Borba Manana wrote:
>> @@ -4307,6 +4348,22 @@ out:
>>       return num_read;
>>  }
>>
>> +static int send_total_data_size(struct send_ctx *sctx, u64 data_size)
>> +{
>> +     int ret;
>> +
>> +     ret = begin_cmd(sctx, BTRFS_SEND_C_TOTAL_DATA_SIZE);
>> +     if (ret < 0)
>> +             goto out;
>> +
>> +     TLV_PUT_U64(sctx, BTRFS_SEND_A_SIZE, data_size);
>> +     ret = send_cmd(sctx);
>> +
>> +tlv_put_failure:
>> +out:
>> +     return ret;
>> +}
>> +
>>  /*
>>   * Send a clone command to user space.
>>   */
>> --- a/fs/btrfs/send.h
>> +++ b/fs/btrfs/send.h
>> @@ -87,6 +87,7 @@ enum btrfs_send_cmd {
>>
>>       BTRFS_SEND_C_END,
>>       BTRFS_SEND_C_UPDATE_EXTENT,
>> +     BTRFS_SEND_C_TOTAL_DATA_SIZE,
>
> Though it is a simple modification, it changes the existing send
> protocol.
>
> The unpatched receiver would fail (it has a lower value of
> __BTRFS_SEND_C_MAX), so it could work even without revving the protocol.
> But, it's not the cleanest way.

Same problem happened when BTRFS_SEND_C_UPDATE_EXTENT was added.
Since it's a command that's only sent if a new special flag is
supplied, I don't think it's that bad.

>
> There's a number of defficiencies found in v1 protocol, see
> https://btrfs.wiki.kernel.org/index.php/Design_notes_on_Send/Receive#Send_stream_v2_draft
>
> I would rather see a proper v2 revision instead of relying on the fact
> that current implementation will deal with the change.

Right, by 2020 we'll have v2 fully specified and maybe implemented :)

Thanks David

>
>>       __BTRFS_SEND_C_MAX,
>>  };
>>  #define BTRFS_SEND_C_MAX (__BTRFS_SEND_C_MAX - 1)



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."

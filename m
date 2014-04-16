Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:41357 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbaDPSHN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 14:07:13 -0400
Received: by mail-la0-f52.google.com with SMTP id ec20so8210186lab.25
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Apr 2014 11:07:12 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140416174316.GD29256@twin.jikos.cz>
References: <1397580051-26643-2-git-send-email-fdmanana@gmail.com>
	<1397660175-8005-1-git-send-email-fdmanana@gmail.com>
	<20140416174316.GD29256@twin.jikos.cz>
Date: Wed, 16 Apr 2014 19:07:12 +0100
Message-ID: <CAL3q7H7aG1t8M0GDQeVQ1On-qpNVx3K3L8=iVw+=J9bDwC1UyQ@mail.gmail.com>
Subject: Re: [PATCH 2/4 v2] Btrfs-progs: send, implement total data size
 callback and progress report
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 16, 2014 at 6:43 PM, David Sterba <dsterba@suse.cz> wrote:
> On Wed, Apr 16, 2014 at 03:56:15PM +0100, Filipe David Borba Manana wrote:
>> V2: Added new send ioctl flag BTRFS_SEND_FLAG_SUPPORT_FALLOCATE. A version 2
>>     stream is now only produced is the ioctl caller specifies at least one of
>>     the new send flags (BTRFS_SEND_FLAG_SUPPORT_FALLOCATE or
>>     BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE).
>
> Good.
>
>> @@ -156,6 +165,12 @@ static int process_subvol(const char *path, const u8 *uuid, u64 ctransid,
>>               goto out;
>>
>>       r->cur_subvol = calloc(1, sizeof(*r->cur_subvol));
>> +     r->total_data_size = 0;
>> +     r->bytes_received = 0;
>> +     r->progress = 0.0;
>> +     r->last_progress_update = 0;
>> +     r->bytes_received_last_update = 0;
>> +     r->target = "Subvolume";
>>
>>       if (strlen(r->dest_dir_path) == 0)
>>               r->cur_subvol->path = strdup(path);
>> @@ -205,6 +220,12 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
>>               goto out;
>>
>>       r->cur_subvol = calloc(1, sizeof(*r->cur_subvol));
>> +     r->total_data_size = 0;
>> +     r->bytes_received = 0;
>> +     r->progress = 0.0;
>> +     r->last_progress_update = 0;
>> +     r->bytes_received_last_update = 0;
>> +     r->target = "Snapshot";
>
> Nontrivial amount of duplicate code, a helper would be better.

Agree about the duplication, but can't agree with being non-trivial:
resetting to 0 a few counters/percentage/timestamp :)

>
>> @@ -673,7 +679,7 @@ out:
>>  }
>>
>>  const char * const cmd_send_usage[] = {
>> -     "btrfs send [-ve] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol> [<subvol>...]",
>> +     "btrfs send [-veo] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol> [<subvol>...]",
>>       "Send the subvolume(s) to stdout.",
>>       "Sends the subvolume(s) specified by <subvol> to stdout.",
>>       "By default, this will send the whole subvolume. To do an incremental",
>> @@ -697,5 +703,9 @@ const char * const cmd_send_usage[] = {
>>       "-f <outfile>     Output is normally written to stdout. To write to",
>>       "                 a file, use this option. An alternative would be to",
>>       "                 use pipes.",
>> +     "-o               Obtain the total data size for each subvolume or ",
>
> UI:
>
> -o is sometimes used as an option for 'output', which makes sense in
> context of send, but is already done via -f. I'm not sure if it's a good
> choice. 'p' is already occupied.
>
> As an alternative: how about -s ? mnemonic for 'size'.

Fine for me. Don't have a strong opinion about the letter.

thanks David

>
>> +     "                 snapshot to send. This demands additional processing",
>> +     "                 (mostly IO bound) but is useful for the receive ",
>> +     "                 command to report progress.",
>>       NULL
>>  };



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."

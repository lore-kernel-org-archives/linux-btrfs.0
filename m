Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:41958 "EHLO
        mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964776AbeBMNei (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 08:34:38 -0500
Received: by mail-yw0-f173.google.com with SMTP id f12so3467077ywb.8
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 05:34:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <c7e267a4-d47d-9713-c222-81dcb441e009@panasas.com>
References: <346220b8-d129-1de9-eb28-6344ec0b0d3a@panasas.com>
 <96cd9e57-cde4-5bc4-0312-02b54668e59a@mendix.com> <76e7f364-62b9-5ef1-a8ed-f6fb9e534963@panasas.com>
 <20180210220549.GA30438@polanet.pl> <6abc187c-b5fe-a776-6b89-ca5b6c7ee790@panasas.com>
 <20c617b6-7179-a67a-3997-8fee766088a5@mendix.com> <c7e267a4-d47d-9713-c222-81dcb441e009@panasas.com>
From: E V <eliventer@gmail.com>
Date: Tue, 13 Feb 2018 08:34:37 -0500
Message-ID: <CAJtFHUQSypeN4t9bpAXfkEgq2Nj4hck3x+17-jaxuH6osJjNGQ@mail.gmail.com>
Subject: Re: btrfs-cleaner / snapshot performance analysis
To: "Ellis H. Wilson III" <ellisw@panasas.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 12, 2018 at 10:37 AM, Ellis H. Wilson III
<ellisw@panasas.com> wrote:
> On 02/11/2018 01:24 PM, Hans van Kranenburg wrote:
>>
>> Why not just use `btrfs fi du <subvol> <snap1> <snap2>` now and then and
>> update your administration with the results? .. Instead of putting the
>> burden of keeping track of all administration during every tiny change
>> all day long?
>
>
> I will look into that if using built-in group capacity functionality proves
> to be truly untenable.  Thanks!
>
>>> CoW is still valuable for us as we're shooting to support on the order
>>> of hundreds of snapshots per subvolume,
>>
>>
>> Hundreds will get you into trouble even without qgroups.
>
>
> I should have been more specific.  We are looking to use up to a few dozen
> snapshots per subvolume, but will have many (tens to hundreds of) discrete
> subvolumes (each with up to a few dozen snapshots) in a BTRFS filesystem.
> If I have it wrong and the scalability issues in BTRFS do not solely apply
> to subvolumes and their snapshot counts, please let me know.
>
> I will note you focused on my tiny desktop filesystem when making some of
> your previous comments -- this is why I didn't want to share specific
> details.  Our filesystem will be RAID0 with six large HDDs (12TB each).
> Reliability concerns do not apply to our situation for technical reasons,
> but if there are capacity scaling issues with BTRFS I should be made aware
> of, I'd be glad to hear them.  I have not seen any in technical
> documentation of such a limit, and experiments so far on 6x6TB arrays has
> not shown any performance problems, so I'm inclined to believe the only
> scaling issue exists with reflinks.  Correct me if I'm wrong.
>
> Thanks,
>
> ellis
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

When testing btrfs on large volumes, especially with metadata heavy
operations, I'd suggest you match the node size of your mkfs.btrfs
(-n) with the stripe size used in creating your RAID array. Also, use
the ssd_spread mount option as discussed in a previous thread. It make
a big difference on arrays. It allocates much more space for metadata,
but it greatly reduces fragmentation over time.

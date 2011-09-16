From: Henti Smith <henti@geekware.co.za>
Subject: Re: Raid0 and drive failure.
Date: Fri, 16 Sep 2011 17:06:03 +0200
Message-ID: <CAC_HdUrh+LhBfHTMKE8VTkuwEgJbcX2mBP3pJFYivk228-VctA@mail.gmail.com>
References: <CAC_HdUrrEzUYp3K=ZAG9sQK=6totXmoy5FswGg=huTuxb6vtnw@mail.gmail.com>
	<CAAeznTp1eX8m--Mw-RFNY8VmU8O08kRNQeOmHAZo=cGNxvV7Tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Leonidas Spyropoulos <artafinde@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAeznTp1eX8m--Mw-RFNY8VmU8O08kRNQeOmHAZo=cGNxvV7Tg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 16, 2011 at 4:49 PM, Leonidas Spyropoulos
<artafinde@gmail.com> wrote:
> On Sep 16, 2011 1:25 PM, "Henti Smith" <henti@geekware.co.za> wrote:
>> Good day.
>>
> Hello

Hi

>> This is likely a newbie question, but I just need to confirm. If you
>> have 3 x 100GB drives in RAID0 and one drive dies this will result in
>> total data loss correct?
>>
> Yes the data are lost. Read more on how raid 0 works.

I have read on how raid 0 works, I was merely asking about the
implementation of raid0 on btrfs.

>> Is there no way to loose only the data that resides (even partly) on
>> the missing drive but retain the rest of the data ?

This is the more pertinent question, which it seem btrfs can't do currently.

Henti

From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: Set nodatacow per file?
Date: Mon, 13 Feb 2012 16:10:24 +0800
Message-ID: <4F38C570.9090205@cn.fujitsu.com>
References: <4F38B8F0.5020506@yahoo.com> <CAAE6i0iHNnr7=BjFOWd8hR99jKKVAfGcFo5GKHLnT6nytWn7jA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ralf-Peter Rohbeck <rohbeck@yahoo.com>, linux-btrfs@vger.kernel.org
To: Chester <somethingsome2000@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAE6i0iHNnr7=BjFOWd8hR99jKKVAfGcFo5GKHLnT6nytWn7jA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/13/2012 03:34 PM, Chester wrote:
> On Mon, Feb 13, 2012 at 1:17 AM, Ralf-Peter Rohbeck <rohbeck@yahoo.com> wrote:
>> Hello,
>> is it possible to set nodatacow on a per-file basis? I couldn't find anything.
>> If not, wouldn't that be a great feature to get around the performance issues with VM and database storage? Of course cloning should still cause COW.
> 
> IIRC this is already a feature in btrfs. I didn't catch the whole
> talk, but Chris mentioned something like this at Scale 10x. I also
> remember seeing a patch for it a while back (I think it was from liu
> bo) that does this.
> 

You're right, and I've made the prog patches which is against linux-ulit(chattr/lsattr):

http://www.spinics.net/lists/linux-btrfs/msg09604.html
http://www.spinics.net/lists/linux-btrfs/msg09605.html

but they are not merged yet.

thanks,
liubo

>> Thanks,
>> Ralf-Peter
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


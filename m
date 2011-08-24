From: Arne Jansen <sensille@gmx.net>
Subject: Re: [RFC] Subvolume Quota on-disk structures and configuration
Date: Wed, 24 Aug 2011 09:53:42 +0200
Message-ID: <4E54AE06.8060109@gmx.net>
References: <4E19611D.2090007@gmx.net> <loom.20110824T083328-979@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Yeh <ykwan0201@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20110824T083328-979@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 24.08.2011 09:26, Yeh wrote:
> Arne Jansen <sensille <at> gmx.net> writes:
> 
>>
>> These 4 commands are used to build hierarchical qgroups and are only
>> for advanced users. I'll explain more of the concepts in a later
>> paper.
>>
>> The main point here is that in the simplest case, a user creates a
>> filesystem with initial quota support, creates his /var /usr /home
>> etc. subvolumes and limits them with commands like
>>
>> btrfs qgroup limit 10g /usr
>>
>> That should be simple enough for the common use case.
>>
>> -Arne
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo <at> vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
> Hello Arne,
> 
> There are some discussion in mailling list topic "What to do about subvolumes".
> It is copy-on-write quota counting.
> One is charged the quota as physical blocks count.
> Another is charged as how much the user looks like.
> Both of them have different limitation.
> What solution would you use?

I have written an earlier mail to sketch out what I intend to implement. I
don't quite understand the 2 counting methods you refer to, but maybe that
earlier mails helps (Subject: Quota Implementation). If not, I can try to
describe in more detail what I implement. Most probably it will meet your
need, unless you expect user quota :)

> 
> The topic you mentioned is what I need. How is your btrfs quota implementation
> progress? You could release your patch for me if possible, I can join your idea,
> design and implementation. I have large disk array for testing.
> 

Still fighting against delayed refs... it might take a few weeks until I have
the first reasonably stable and cleaned-up version.

-Arne

> Best regards,
> Yeh.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


From: Josef Bacik <josef@redhat.com>
Subject: Re: Honest timeline for btrfsck
Date: Fri, 07 Oct 2011 10:50:04 -0400
Message-ID: <4E8F119C.70006@redhat.com>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com> <4E5FE9FC.9040705@cchtml.com> <20110901203442.GA17928@carfax.org.uk> <201109101209.40759.Martin@lichtvoll.de> <CA+JuuGrvCTP=o8umQHQV968tMSfJzxAFOfnGO2RKV3RU4_Vshw@mail.gmail.com> <20111005061628.GA3702@shiny.elevennetworks.com> <CA+JuuGoG1rhQ9S+vfa17BKdekp-A1UeNHqeYEwxfg=Co3Ts_pQ@mail.gmail.com> <20111005145843.GA4770@shiny.elevennetworks.com> <CA+JuuGq8ODcFDh_KEy3YL_pVJ1=zKDX1SD_9Ou_tHpR4XGhwgQ@mail.gmail.com> <m239f550cp.fsf@firstfloor.org> <CAD6zcDxvXTZPOO-bXRfuMVWqOGbz8QdfHk=p0LT6Dequb9pmAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Putney <jeffrey.putney@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Francesco Riosa <vivo75@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAD6zcDxvXTZPOO-bXRfuMVWqOGbz8QdfHk=p0LT6Dequb9pmAg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/06/2011 04:56 PM, Francesco Riosa wrote:
> 2011/10/6 Andi Kleen <andi@firstfloor.org>:
>> Jeff Putney <jeffrey.putney@gmail.com> writes:
>>>
>>> http://en.wikipedia.org/wiki/Release_early,_release_often
>>
>> Well the other principle in free software you're forgetting
>> is:
>>
>> "It will be released when it's ready"
>>
>> If you don't like Chris' ways to do releases you're free to write
>> something on your own or pay someone to do so. Otherwise
>> you just have to deal with his time frames, as shifty
>> as they may be.
> 
> I did a different thing, I've offered Chris money to help rescue an
> hosed btrfs or to point to someone who could do, we ended in doing
> some tests (for free) but nothing else materialized.
> While the time passed has diminished the value of the data to be
> rescued I'm more on the "show us some code we can start from" than "it
> will be released when ready" vagon.
> 

If you still need that data, clone this repo

git://github.com/josefbacik/btrfs-progs.git

run make, and then run

./restore /dev/whatever /some/dir

and it will try and suck all of your data off the disk and dump it in
that directory.  If you have snapshots it will skip them by default, so
if you have snapshots that have useful data in them you'll want to use
the -s option.  If you run into random errors that you think are
recoverable, or if you don't care about the file that's being recovered,
you can run with -i which will ignore errors and keep trying to recover
your files.  Thanks,

Josef

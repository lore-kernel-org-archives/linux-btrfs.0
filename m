From: Josef Bacik <josef@redhat.com>
Subject: Re: Honest timeline for btrfsck
Date: Fri, 07 Oct 2011 12:08:56 -0400
Message-ID: <4E8F2418.10603@redhat.com>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com> <4E5FE9FC.9040705@cchtml.com> <20110901203442.GA17928@carfax.org.uk> <201109101209.40759.Martin@lichtvoll.de> <CA+JuuGrvCTP=o8umQHQV968tMSfJzxAFOfnGO2RKV3RU4_Vshw@mail.gmail.com> <20111005061628.GA3702@shiny.elevennetworks.com> <CA+JuuGoG1rhQ9S+vfa17BKdekp-A1UeNHqeYEwxfg=Co3Ts_pQ@mail.gmail.com> <20111005145843.GA4770@shiny.elevennetworks.com> <CA+JuuGq8ODcFDh_KEy3YL_pVJ1=zKDX1SD_9Ou_tHpR4XGhwgQ@mail.gmail.com> <20111007025050.GA4767@shiny.Netlink.Wireless> <CA+JuuGo-iREXO4cZKT61tHZMTAr_edBv=O51-uSA7Bgynbgu6w@mail.gmail.com> <4E8F1128.4000508@redhat.com> <CA+JuuGopTsEWpeW5GnwjR-NuJgUwte6HGvhSTUfm_Wh0itVpdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Jeff Putney <jeffrey.putney@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CA+JuuGopTsEWpeW5GnwjR-NuJgUwte6HGvhSTUfm_Wh0itVpdg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/07/2011 11:58 AM, Jeff Putney wrote:
> The rescue tool may have a lot of the logic I personally am most
> interested in reading.  Thank you for that!
> 
>> The problem is people won't just read it, they will use it.
> 
> I've read every last line of the current btrfsck, even though it
> doesn't do anything.  I am interested in the source specifically to
> read it.
> 
>> I wrote a
>> basic repair tool for a user in Fedora who seemed to have a very
>> specific kind of corruption, and earlier this week almost a month after
>> my initial repair tool I had to write another tool to go in and just
>> pull all his data off his disk because a bug in my repair tool made his
>> fs _WORSE_, to the point I'm not sure I can fix it.
> 
> These are specifically the types of one off solutions that are having
> to be done because the source hasn't been released for the community
> to finish up.
> 
>> Fsck has the
>> potential to make any users problems worse, and given the increasing
>> number of people putting production systems on btrfs with no backups the
>> idea of releasing a unpolished and not fully tested fsck into the world
>> is terrifying, and would likely cause long term "I heard that file
>> system's fsck tool eats babies" sort of reputation.
> 
> I fail to see the distinction between releasing an unpolished fsck vs
> releasing an unpolished fs driver.  They are collaborating parts of
> the same system.  Whether they say btrfsck eats babies or btrfs eats
> babies, they are still saying that the babies are getting eaten.
> 
>> Release early and release often is nice for web browsers and desktop
>> environments, it's not so nice with things that could result in data
>> loss, especially when our user base is growing in leaps and bounds and
>> aren't necessarily informed enough on the dangers of using an file
>> system that's still under heavy development.
> 
> What you are saying is that the specter of increased data loss somehow
> outweighs the combined benefit that the community has to offer.
> Unless the current state of the project IS due solely to the work of
> Chris and Josef, and you don't feel that the community at large has
> provided meaningful contributions, than I think that's a pretty
> skeptical and unappreciative attitude towards all of the people who
> HAVE contributed to this project.
> 
> The 'specialness' of an fsck tool is highly suspect.  Current
> development versions of all the other fsck tools are available in
> their respective repositories, and yet headlines of their eating
> babies are still pretty scarce.
> I'm glad that Linus didn't use your logic when it came to releasing
> the linux kernel.  Do you think the entire linux kernel is more like a
> web browser, or a desktop environment?
> 
> This smells more like post hoc justification of being territorial over
> a pet project than it does actual reasons for keeping the source a
> state secret of oracle.  Unless their is no intention of releasing the
> source, and Oracle intends to keep it a closed source product for
> their own linux distributions alone.

Well you've caught us, this is all just a conspiracy to keep the users
under our thumbs and to block out any contributions.  Sorry Chris, we
kept it up for a good year tho!

Josef

From: "David Pottage" <david@electric-spoon.com>
Subject: Re: corrupted btrfs volume: parent transid verify failed
Date: Mon, 15 Aug 2011 10:51:50 +0100
Message-ID: <0fc603e0a5f95843f48701afcbe59fa6.squirrel@www.chrestomanci.org>
References: <CABqt_RND8Bd8NJ5cniKP=ySBBh6+p_xyoJh9ZL2aJeR9Sb4qrQ@mail.gmail.com>
    <CABqt_RNd55S6fLgm6nteGq7kvgF9D33m4a_7ahNasSug-_tGeA@mail.gmail.com>
    <4E4855FF.2040806@cchtml.com>
    <CABqt_RN0+0Wj9qM3sEKR-C76_CeL-sLN5EsVWicuZEJDAp4AZA@mail.gmail.com>
    <4E485F9C.8000909@cchtml.com>
    <CABqt_RMQHkzrQfPVHiL-DmWe21Y8eqjVfXEYdSDxDXWOFf3qKQ@mail.gmail.com>
    <CAE5mzvjv0eaW_1ECVyOg+39H8Sp_wJBuMWoAbd2Qj5hpBAj_2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org,
	"Michael Cronenworth" <mike@cchtml.com>
To: "cwillu" <cwillu@cwillu.com>,
	"Yalonda Gishtaka" <yalonda.gishtaka@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAE5mzvjv0eaW_1ECVyOg+39H8Sp_wJBuMWoAbd2Qj5hpBAj_2Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


> Regarding your backup regimen, consider using rsync instead of dd:
> after the initial backup, rsync can update the existing backup _much_
> more quickly, making it practical to do a backup every night, or even
> multiple times a day.  dd also has the downside of potentially
> _really_ confusing btrfs if it ever sees the backup and the original
> at the same time.

A still better option is to use an online backup service such as crashplan
or spideroak, as that way your backups are also safe from fire or theft.
Also most will automatically create incremental backups several times per
hour, so that you can access old versions of your file easily.

Crashplan has a free online backup service where you backup to a friend's
computer over the internet instead of to their servers. Another cheap
alternative for small and very important files is to email them to your
google mail account so you can retrieve lost files from any computer.

I know of one Comp Sci professor who advises all his students to use that
email method of backup for important thesis and suchlike as well as any
other backup method. His argument is that if a student's room mate gets
arrested, then the cops are likely to take away all computers and backup
media, so in that case an online backup will be the only usable one.

-- 
David Pottage

Error compiling committee.c To many arguments to function.


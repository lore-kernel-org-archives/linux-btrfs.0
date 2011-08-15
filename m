From: cwillu <cwillu@cwillu.com>
Subject: Re: corrupted btrfs volume: parent transid verify failed
Date: Mon, 15 Aug 2011 02:03:03 -0600
Message-ID: <CAE5mzvjv0eaW_1ECVyOg+39H8Sp_wJBuMWoAbd2Qj5hpBAj_2Q@mail.gmail.com>
References: <CABqt_RND8Bd8NJ5cniKP=ySBBh6+p_xyoJh9ZL2aJeR9Sb4qrQ@mail.gmail.com>
	<CABqt_RNd55S6fLgm6nteGq7kvgF9D33m4a_7ahNasSug-_tGeA@mail.gmail.com>
	<4E4855FF.2040806@cchtml.com>
	<CABqt_RN0+0Wj9qM3sEKR-C76_CeL-sLN5EsVWicuZEJDAp4AZA@mail.gmail.com>
	<4E485F9C.8000909@cchtml.com>
	<CABqt_RMQHkzrQfPVHiL-DmWe21Y8eqjVfXEYdSDxDXWOFf3qKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, Michael Cronenworth <mike@cchtml.com>
To: Yalonda Gishtaka <yalonda.gishtaka@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CABqt_RMQHkzrQfPVHiL-DmWe21Y8eqjVfXEYdSDxDXWOFf3qKQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

There are patches elsewhere in the mailing list to allow one to mount
a broken-due-to-transid-mismatch  filesystem readonly, which should
work in this case.

Regarding your backup regimen, consider using rsync instead of dd:
after the initial backup, rsync can update the existing backup _much_
more quickly, making it practical to do a backup every night, or even
multiple times a day.  dd also has the downside of potentially
_really_ confusing btrfs if it ever sees the backup and the original
at the same time.

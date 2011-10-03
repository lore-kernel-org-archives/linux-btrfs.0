From: Avi Kivity <avi.kivity@gmail.com>
Subject: Re: Suddenly, a dead filesystem
Date: Mon, 3 Oct 2011 20:07:35 +0200
Message-ID: <CAEbWaio2+c9iNjkQYnQv+=UKdR5=zpMne40RCa2X2wBObfJnxw@mail.gmail.com>
References: <CAEbWaipxhyMf2VQRdfnpMcXwyf84YupLOm8hQRf4Q8wJu060ng@mail.gmail.com>
	<4E53B7DC.7020807@redhat.com>
	<CAEbWaipUPoO95kbmewfi1j=tBk5gv4Ui6yY8XSOpGHJH9KQpNQ@mail.gmail.com>
	<CAEbWairrpVkcnDb37O2dF+sQxnmmP7+N2sBd=-pdCNVOH9n8eg@mail.gmail.com>
	<4E89C80B.40601@redhat.com>
	<CAEbWair966=m=4Fe_ipZNJk5PB381t_1gJ+TYPZ_naP8s=eJsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAEbWair966=m=4Fe_ipZNJk5PB381t_1gJ+TYPZ_naP8s=eJsw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

>>
>> Thats -EIO, is there any messages before the bug? =A0Thanks,
>>
>
> Not that I recall. =A0I'll check again when I'm near the poor thing a=
gain.
>

Confirmed - that's the first relevant message.

As to -EIO, I dd'ed the entire volume and no errors were found.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

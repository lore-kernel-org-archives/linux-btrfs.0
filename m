From: Aditya Bhargava <heuristicist@gmail.com>
Subject: Re: Handsfree Agent not registered
Date: Fri, 17 Feb 2012 06:15:49 -0500
Message-ID: <CAFq8ap==C-P3svMvtxRuNZ53jnfy9gG10AKzQCLLjkb7ALnH7g@mail.gmail.com>
References: <CAFq8ap=MVv84RmLy+g-Pp=b4H9R0RSSNt=8rxTAQuhG1QvV_Yw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAFq8ap=MVv84RmLy+g-Pp=b4H9R0RSSNt=8rxTAQuhG1QvV_Yw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Ack, sorry all, sent to the wrong list.

On Fri, Feb 17, 2012 at 06:08, Aditya Bhargava <heuristicist@gmail.com> wrote:
> Hello all,
>
> I'm mucking around trying to get my desktop computer (Ubuntu 11.10,
> BlueZ 4.96, ASUS USB-BT211 USB Bluetooth adapter, no microphone hooked
> up at the moment) to act as a a hands-free device for my phone (Nexus
> S). It was relatively simple getting it set up for A2DP, and I was
> able to play music that is on my phone through my desktop's speakers
> (using PulseAudio loopback). But when I try to tell PulseAudio to use
> the Handsfree profile instead (so that this would work for phone calls
> too) I get an error. Checking the syslog shows that, when the phone
> connects to the computer, bluetoothd issues the message "Handsfree
> Agent not registered". I skimmed the source code that generates this
> error and, not having any clue about anything related to BlueZ,
> couldn't find any further information about what is going wrong. Does
> anyone have any ideas? I realize I haven't provided much information
> here so please let me know what else I can provide to help track down
> this problem. My phone's speaker can be rather soft so I want to get
> it hooked up to some proper speakers! Many thanks in advance :)
